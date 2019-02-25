# 如果是非交互式 shell 则直接退出
[[ $- != *i* ]] && return
case $- in
    *i*) ;;
      *) return;;
esac

# 启动 tmux
[[ -z "$TMUX" ]] && exec tmux

# 启动 autojump
. /usr/share/autojump/autojump.sh

# 不把重复的行和空格开头的行加入历史记录
HISTCONTROL=ignoreboth
# 设置历史记录大小
HISTSIZE=1000
HISTFILESIZE=2000

# 追加历史记录而不是覆盖
shopt -s histappend
# 执行每个命令后检查窗口大小并且在必要时更新行数和列数
shopt -s checkwinsize

# 启用补全
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# 设置提示符
PS1='$(
    if [[ $? == 0 ]]; then
        echo "\[\e[1;32m\]:) ";
    else
        echo "\[\e[1;31m\]:( ";
    fi
    )$(
    if [[ ${EUID} == 0 ]]; then
        echo "\[\e[1;31m\]\u ";
    else
        echo "\[\e[1;36m\]\u ";
    fi
    )$(
    echo "\[\e[1;32m\]\w "
    )$(
    if [[ -d .git ]]; then
        echo "\[\e[1;33m\](`git status | head -n 1 | grep -o "\b\S*$"`) ";
    fi
    )$(
    if [[ ${EUID} == 0 ]]; then
        echo "\[\e[1;31m\]\$ ";
    else
        echo "\[\e[1;36m\]\$ ";
    fi
    )\[\e[0m\]'

# 设置别名
alias grep='grep --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -F --color=auto'
alias info='info --vi-keys'
alias en='export LANG=en_US.UTF-8 && export LANGUAGE=en_US'
alias zh='export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN'
alias ..='cd ..'

alias au='sudo apt update'
alias al='apt list'
alias as='apt show'
alias ap='apt policy'
alias alu='sudo apt list --upgradable'
alias af='sudo apt full-upgrade'
alias ai='sudo apt install'
alias ar='sudo apt remove --purge'
alias aar='sudo apt autoremove --purge'
alias aac='sudo apt autoclean'

alias gl='git log'
alias glr='git log --graph'
alias gs='git status'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit'
alias gca='git commit --amend'
alias gpl='git pull'
alias gps='git push'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gch='git checkout'
alias gcm='git checkout master'
alias gdm='git diff master'
alias gsl='git stash list'
alias gsi='git stash push'
alias gso='git stash pop'
alias gsd='git stash drop'
alias gss='git stash show -p'

#alias gr='git review -r origin'
gr() {
    branch_array=($(git branch | cut -b 3-))

    index=1
    for branch in "${branch_array[@]}"; do
        if [[ $branch == master ]]; then
            echo "[$index] $branch"
        else
            echo " $index  $branch"
        fi
        index=$(expr $index + 1)
    done

    echo -n "specify a branch to review: "
    read selected_index

    # default branch is master
    if [[ -z $selected_index ]]; then
        echo "review to branch master:"
        git review -r origin master
        return $?
    fi

    selected_branch=${branch_array[$selected_index]}
    if [[ -n $selected_branch ]]; then
        echo "review to branch $selected_branch: "
        git review -r origin $selected_branch
        return $?
    else
        echo "Error: specified branch can not find!";
    fi
}

#alias grm='git rebase master'
grm() {
    flag=$(git branch | grep "\\* dev/")
    if [[ -n $flag ]]; then
        echo "Warning: rebase master in dev branch!"
        echo "use complete command 'git rebase master' if you really want to do this!"
    else
        git rebase master
    fi
}

alias m='make -j4'
alias mk='make'

alias dd='dd status=progress'

# 让所有 alias 支持 bash 补全
. "$HOME"/.bash_completion_alias
aliasArray=($(alias | sed -e '{s/alias //;s/=.*//}'))
for ali in "${aliasArray[@]}"; do
    complete -F _complete_alias "$ali"
done

# 设置有颜色的 man 手册
man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;41;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  man "$@"
}

# 设置变量

export EDITOR=vim

# java
#export JAVA_HOME=/usr/lib/jvm/default
#export JRE_HOME=$JAVA_HOME/jre
#export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#export PATH=$PATH:$JAVA_HOME/bin
unset _JAVA_OPTIONS

# android
#export ANDROID_HOME=/home/ri/android-sdk-linux
#export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# golang
export GOROOT=/usr/lib/go
export GOPATH=/home/ri/go

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/shells:$PATH:/usr/local/sbin:/usr/sbin:/sbin
