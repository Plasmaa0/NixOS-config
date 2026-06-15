#!/usr/bin/env bash
# set -euo pipefail

LRCLIB_API="https://lrclib.net/api/get"

# Get lyrics from LRCLIB API
# Arguments:
#   $1 = artist_name
#   $2 = album_name (can be empty)
#   $3 = track_name
get_lyrics() {
    local artist="$1"
    local album="$2"
    local title="$3"
    
    curl -sG \
        --data-urlencode "artist_name=$artist" \
        --data-urlencode "track_name=$title" \
        --data-urlencode "album_name=$album" \
        "$LRCLIB_API" \
        | jq -r '.syncedLyrics // empty'
}

# Clean leading "The" (case-insensitive) from strings
clean_leading_the() {
    echo "$1" | sed -E 's/^[[:space:]]*[Tt][Hh][Ee][[:space:]]+//; s/^[[:space:]]+//; s/[[:space:]]+$//'
}

# Process a single music file
# Arguments:
#   $1 = path to music file
process_file() {
    local file="$1"
    local base="${file%.*}"
    local lrc_file="${base}.lrc"
    
    # Skip if lyrics file already exists
    if [[ -f "$lrc_file" ]]; then
        echo "→ Skipping \"$(basename "$file")\" - lyrics file already exists"
        return 0
    fi

    # Extract metadata with case-insensitive matching
    local ffmeta
    ffmeta=$(ffprobe -loglevel error -show_entries format_tags -of json "$file" 2>/dev/null) || {
        echo "⚠ Skipping \"$(basename "$file")\" - ffprobe failed to read metadata"
        return 1
    }

    # Extract tags case-insensitively
    local artist album_artist album title
    artist=$(jq -r '.format.tags | to_entries[] 
        | select(.key | ascii_downcase == "artist") 
        | .value // empty' <<< "$ffmeta")
    
    album_artist=$(jq -r '.format.tags | to_entries[] 
        | select(.key | ascii_downcase == "album_artist") 
        | .value // empty' <<< "$ffmeta")
    
    album=$(jq -r '.format.tags | to_entries[] 
        | select(.key | ascii_downcase == "album") 
        | .value // empty' <<< "$ffmeta")
    
    title=$(jq -r '.format.tags | to_entries[] 
        | select(.key | ascii_downcase == "title") 
        | .value // empty' <<< "$ffmeta")

    # Determine artist name to use (prefer album_artist if available)
    local artist_name="${album_artist:-$artist}"
    
    # Skip if critical metadata is missing
    if [[ -z "$artist_name" ]] || [[ -z "$title" ]]; then
        echo "✗ Skipping \"$(basename "$file")\" - missing artist ($artist_name) or title ($title) metadata"
        return 1
    fi

# Attempt 1: Original metadata
    local lyrics stripped_title artist_clean album_clean title_clean
    # echo "Trying '$artist_name' '$album' '$title'"
    lyrics=$(get_lyrics "$artist_name" "$album" "$title" 2>/dev/null) || lyrics=""
    
    # Attempt 2: Stripped title (remove parentheticals)
    if [[ -z "$lyrics" ]]; then
        stripped_title=$(sed -E 's/ *\([^)]*\)//g' <<< "$title")
        # echo "Trying '$artist_name' '$album' '$stripped_title'"
        lyrics=$(get_lyrics "$artist_name" "$album" "$stripped_title" 2>/dev/null) || lyrics=""
    fi
    
    # Attempt 3: Remove leading "The" from all fields + stripped title
    if [[ -z "$lyrics" ]]; then
        artist_clean=$(clean_leading_the "$artist_name")
        album_clean=$(clean_leading_the "$album")
        title_clean=$(clean_leading_the "$stripped_title")
        # echo "Trying '$artist_clean' '$album_clean' '$title_clean'"
        lyrics=$(get_lyrics "$artist_clean" "$album_clean" "$title_clean" 2>/dev/null) || lyrics=""
    fi
    
    # Attempt 4: Remove leading "The" from artist only + stripped title
    if [[ -z "$lyrics" ]]; then
        artist_clean=$(clean_leading_the "$artist_name")
        # echo "Trying '$artist_clean' '$album' '$stripped_title'"
        lyrics=$(get_lyrics "$artist_clean" "$album" "$stripped_title" 2>/dev/null) || lyrics=""
    fi

    # Handle failed lookup
    if [[ -z "$lyrics" ]]; then
        echo "✗ No lyrics found for \"$(basename "$file")\" after all attempts"
        return 0
    fi

    # Save cleaned lyrics (remove metadata lines)
    sed -E '/^\[(ar|al|ti|au|by|re|ve):/d' <<< "$lyrics" > "$lrc_file"
    echo "✓ Saved lyrics to \"$(basename "$lrc_file")\" (after ${attempt:-1} attempts)"
}

# Verify dependencies
for cmd in ffprobe jq fd curl; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: Required command '$cmd' not found" >&2
        exit 1
    fi
done

# Main execution
if [[ $# -ne 1 ]] || [[ ! -d "$1" ]]; then
    echo "Usage: $0 <music_directory>"
    echo "Example: $0 ~/Music"
    exit 1
fi

music_dir=$(realpath "$1")

# Find all music files
mapfile -t music_files < <(fd . -t f -e mp3 -e flac -e ogg -e m4a -e wma -e opus -e aac --color=never "$music_dir")

total=${#music_files[@]}
if [[ $total -eq 0 ]]; then
    echo "No music files found in: $music_dir"
    exit 0
fi

echo "Found $total music files in: $music_dir"
echo "Processing files..."

# Process all music files with progress bar
count=0
for file in "${music_files[@]}"; do
    ((count++))
    
    # Update progress bar
    percent=$((count * 100 / total))
    bar_width=25
    filled=$((bar_width * count / total))
    empty=$((bar_width - filled))

    # Build progress bar with # and -
    bar=$(printf "%*s" "$filled" | tr ' ' '#')
    space=$(printf "%*s" "$empty" | tr ' ' '-')

    # Print progress on same line (CR without LF)
    printf "\rProgress: [%s%s] %d/%d (%d%%)" "$bar" "$space" "$count" "$total" "$percent"
    
    # Process the file
    process_file "$file"
done

# Print final newline after progress bar
echo
echo "Processing complete! Processed $count files."
