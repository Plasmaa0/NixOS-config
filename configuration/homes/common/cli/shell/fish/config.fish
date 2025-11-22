## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT 1
export MANROFFOPT="-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

## Export variable need for qt-theme
if type qtile >>/dev/null 2>&1
    set -x QT_QPA_PLATFORMTHEME qt5ct
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

## Starship prompt
if status --is-interactive
    source ("starship" init fish --print-full-init | psub)
    function starship_transient_rprompt_func
        starship module time
    end
    enable_transience
end

## Advanced command-not-found hook
# source /usr/share/doc/find-the-command/ftc.fish

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# thefuck --alias | source
jump shell fish | source
direnv hook fish | source
just --completions fish | source

function take --argument dir
    mkdir -p $dir
    cd $dir
end

function unwrap --argument dir
    mv dir/.* .
    mv dir/* .
    rmdir $dir
end

# wwc: Work with config (creates normal file instead of nix symlink) ONLY FOR DEBUGGING AND TESTING PURPOSES
function wwc -a f
    cat $f >$f.backup
    unlink $f
    cp $f.backup $f
    chmod 777 $f
    chown $(whoami) $f
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

export EDITOR=hx
## Useful aliases
# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias lsg='exa -al --color=always --group-directories-first --icons --git' # preferred listing

alias la='exa -a --color=always --group-directories-first --icons' # all files and dirs
alias lag='exa -a --color=always --group-directories-first --icons --git' # all files and dirs

alias ll='exa -l --color=always --group-directories-first --icons' # long format
alias llg='exa -l --color=always --group-directories-first --icons --git' # long format

alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias ltg='exa -aT --color=always --group-directories-first --icons --git' # tree listing
alias l.="exa -a | egrep '^\.'" # show only dotfiles
alias ip="ip -color"
alias hexdup="hexd"
alias ol="ollama"
abbr nixrepl "nix repl --expr \"{pkgs = import <nixpkgs> {};}\""

# custom
alias perlin="/home/plasmaa0/infa/perlinfetch/venv/bin/python /home/plasmaa0/infa/perlinfetch/perlinfetch.py"
alias color="yad --color"
alias cal="yad --calendar"
# alias hx="helix"
alias cls="clear"
alias учше="exit"
alias weather="curl v1.wttr.in/Moscow && read -P 'Press RETURN to continue' && curl v2.wttr.in/Moscow"
# alias rm='echo "This is not the command you are looking for. (use trm)"; false'
abbr trm trash-put
abbr pacs sudo pacman -S
abbr pacr sudo pacman -R
abbr gumer sshpass -p bmstu ssh -p 3002 student@virtual.fn11.bmstu.ru
abbr venv source venv/bin/activate.fish
abbr olr ollama run
abbr olp ollama ps
abbr olP ollama pull
abbr ols ollama stop

# trash-cli
# set cmds (trash-empty trash-list trash-restore trash-put trash)
# for cmd in $cmds; do
#   $cmd --print-completion bash | sudo tee /usr/share/bash-completion/completions/$cmd
#   $cmd --print-completion zsh | sudo tee /usr/share/zsh/site-functions/_$cmd
#   $cmd --print-completion tcsh | sudo tee /etc/profile.d/$cmd.completion.csh
# end

# git abbreviations
abbr icat wezterm imgcat
# abbr fastfetch ~/infa/nitch/nitch
abbr gd "git diff --color | diff-so-fancy"
abbr gD "git diff --color | diffnav"
abbr glg git log --graph --decorate --oneline

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
alias sk='sk --ansi -i -c "rg --color=always --line-number {}"'
alias fzf='fzf --preview "bat --style header --style snip --style changes --style header {} --color=always" --preview-label="Preview"'

# Common use
alias grubup="sudo update-grub"
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias cdr='cd $(git rev-parse --show-toplevel)'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

## Run fastfetch if session is interactive
if status --is-interactive && type -q fastfetch
    # fastfetch --load-config neofetch
    # ~/infa/nitch/nitch
    # treefetch -b
    # /home/plasmaa0/infa/perlinfetch/venv/bin/python /home/plasmaa0/infa/perlinfetch/perlinfetch.py
    # pokeget random --hide-name
    pokeget random --hide-name | fastfetch --file-raw -
    # fastfetch
end
# pyenv init - | source
