autoload colors && colors

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

function collapse_pwd {
  echo "%{$fg_bold[red]%}$(pwd | sed -e "s,^$HOME,~,")$reset_color"
}

parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
    SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "%{$fg[red]%}$(git rev-parse --abbrev-ref HEAD)"
  else
    echo "%{$fg[cyan]%}$(git rev-parse --abbrev-ref HEAD)"
  fi
}

function git_prompt_info() {
  ref=$($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'}) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function check_tmux() {
  if [[ -n $TMUX ]]; then
    echo '¤'
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[blue]%}(%{$fg_bold[yellow]%}$(ruby_version)%{$fg_bold[blue]%})%{$reset_color%}"
  else
    echo ""
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
echo "%{$fg_bold[blue]%}(%{\e[0;33m%}${ref#refs/heads/}%{$fg_bold[blue]%})%{$reset_color%}"
 # echo "${ref#refs/heads/}"
}
unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

local ret_status="$(check_tmux)%(?:%{$fg_bold[green]%}»:%{$fg_bold[red]%}»%s)"
PROMPT='╭─${ret_status} $(collapse_pwd)$(rb_prompt)$(git_prompt_info)$(need_push)
╰─➤ '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})"
