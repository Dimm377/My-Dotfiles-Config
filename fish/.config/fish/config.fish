if status is-interactive
    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    # Common aliases
    alias c='clear'
    # Smart cat: render by file type
    function cat
        if test (count $argv) -eq 0
            command bat --paging=auto
            return
        end

        for arg in $argv
            if string match -q -- '-*' $arg
                command bat $argv
                return
            end
        end

        for target in $argv
            if not test -e "$target"
                printf 'cat: %s: No such file or directory\n' "$target" >&2
                continue
            end

            if test -d "$target"
                command ls -ld -- "$target"
                continue
            end

            set lower_target (string lower -- "$target")
            if string match -q -r '\\.(md|markdown)$' "$lower_target"
                if command -q glow
                    command glow -w 0 -- "$target"
                else
                    command bat --paging=auto -- "$target"
                end
                continue
            end

            set mime (command file --brief --mime-type -- "$target")
            switch $mime
                case 'image/*'
                    if command -q kitten
                        command kitten icat -- "$target"
                    else
                        command file -- "$target"
                    end
                case 'text/markdown' 'text/x-markdown'
                    if command -q glow
                        command glow -w 0 -- "$target"
                    else
                        command bat --paging=auto -- "$target"
                    end
                case 'application/pdf'
                    if command -q pdftotext
                        command pdftotext -layout -- "$target" - | command bat --paging=auto --language=markdown
                    else
                        command file -- "$target"
                    end
                case 'text/*' 'application/json' 'application/*+json' 'application/yaml' 'application/x-yaml' 'application/toml'
                    command bat --paging=auto -- "$target"
                case '*'
                    printf '%s: binary file (%s)\n' "$target" "$mime"
            end
        end
    end
    alias grep='rg'
    alias v='nvim'
    alias update='sudo pacman -Syu'
    alias install='paru -S'
    alias search='paru -Ss'
    alias cleanup='paru -Sc'

    # Custom colours
    command cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    # Custom fish config
    set -q XDG_CONFIG_HOME && set -l cConf $XDG_CONFIG_HOME/caelestia || set -l cConf $HOME/.config/caelestia
    source $cConf/user-config.fish 2> /dev/null
end


# Added by Antigravity CLI installer
set -gx PATH "/home/dimm/.local/bin" $PATH
