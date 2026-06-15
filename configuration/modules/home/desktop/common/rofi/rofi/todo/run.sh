edit="  Edit"
view="🖺 View"
new=" New"

run_fzf() {
	echo -e "${view}\n${edit}\n${new}" | fzf --height 40% --layout reverse --border
}

edit(){
    MAIN_TAB_CMD="hx $1"
    SECOND_TAB_CMD="typst w $1 --open zathura -j $(nproc --all)"

    SESSION_FILE=$(mktemp)
cat <<EOF > "$SESSION_FILE"
new_tab Edit
launch bash -c "$MAIN_TAB_CMD"
new_tab Compile
launch bash -c "$SECOND_TAB_CMD"
EOF
    kitty --session "$SESSION_FILE"
    rm "$SESSION_FILE"
}

chosen=$(run_fzf)
mkdir -p ~/Documents/todo
cd ~/Documents/todo || exit
case ${chosen} in
    "$edit")
  	f=$(fd -e typ | fzf --height 40% --layout reverse --border)
  	full_file="$(pwd)/$f"
  	edit "$full_file"
        ;;
    "$view")
  	f=$(fd -e typ | fzf --height 40% --layout reverse --border)
  	full_file="$(pwd)/$f"
    typst c "$full_file" --open zathura -j "$(nproc --all)"
        ;;
    "$new")
    fzf_out=$(fd -e typ | fzf --height 40% --layout reverse --border --print-query --prompt "New todo name: " --preview "echo New file will be created {q}.typ" --preview-window=down:20%:wrap)
    selection=$(echo "${fzf_out}" | tail -1)
    input=$(echo "${fzf_out}" | head -1)
    echo "Selection: ${selection}"
    echo "Input: ${input}"
  	full_file="$(pwd)/$input.typ"
  	touch "$full_file"
    edit "$full_file"
        ;;
esac

