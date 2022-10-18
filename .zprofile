function parse_git_branch() {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ "HEAD" = "$branch" ]; then
        echo "(no branch)"
    else
        echo "$branch"
    fi
}

# feb2021: tmux is losing some keybidings, ctrl - a/e/f/b/n/p stop working, manually setting it fixes it
set -o emacs

# needed to make git/hostname function for cmd substitution in prompt
setopt prompt_subst

function set_ps1_hostname() {
    [ -z "${ZSH_PS1_HOSTNAME}" ] && ZSH_PS1_HOSTNAME="${bold}${yellow}%m"
    echo $ZSH_PS1_HOSTNAME
}

# NOTE: previously i used echo -e ansi codes for colors and resets. The resets escape codes in particular
# caused immediate previous lines in the shell history to be deleted every time i toggled tmux pane zooming
# They ALSO caused ctrl-r fzf to delete the last line in the history as well
PROMPT='(%(?.√.?%?))%F{yellow}%n%F{015}@$(set_ps1_hostname) %F{12}[%F{2}%D{%y-%m-%f} %D{%L:%M:%S}%F{12}] (%F{cyan}%~%F{12}) <%F{magenta}$(parse_git_branch)%F{12}>%f'$'\n''$ '
# PROMPT='(%(?.√.?%?))%F{yellow}%n%F{015}@$(set_ps1_hostname) %F{12}(%F{cyan}%~%F{12}) <%F{magenta}$(parse_git_branch)%F{12}>%f'$'\n''$ '
# PROMPT="%n %m %~"$'\n'"$ "
