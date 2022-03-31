# 如果是非交互式 shell 则直接退出
[[ $- != *i* ]] && return
case $- in
    *i*) ;;
      *) return;;
esac

IsOSX=$(uname -a | grep -i Darwin)

export PATH=$HOME/bin:$HOME/scripts/shell:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH

if [[ -n $IsOSX ]]; then
    # 禁止 brew 自动更新仓库
    export HOMEBREW_NO_AUTO_UPDATE=1
    # 使用 brew 安装的 bash
    export SHELL=/usr/local/bin/bash
fi

# 在不是以下情况的时候，连接已有的或者启动新的 tmux 会话
# 1. 通过 ssh 远程连接
# 2. 在 vscode 启动初始化时
# 3. 在 vscode 内置 terminal 中
if [[ -z $SSH_CONNECTION && -z $VSCODE_PID && -z $IS_VSCODE_INTEGRATED_TERMINAL ]]; then
    which tmux > /dev/null 2>&1 \
        && [[ -z "$TMUX" ]] \
        && { if tmux ls > /dev/null 2>&1; then exec tmux a; else exec tmux; fi; }
else
    echo "-> disabled tmux <-"
fi

# 启动 autojump
if [ -s $HOME/.autojump/share/autojump/autojump.bash ]; then
    source $HOME/.autojump/share/autojump/autojump.bash
elif [ -s /usr/local/share/autojump/autojump.bash ]; then
    source /usr/local/share/autojump/autojump.bash
elif [ -s /usr/share/autojump/autojump.bash ]; then
    source /usr/share/autojump/autojump.bash
fi

# 不把重复的行和空格开头的行加入历史记录
HISTCONTROL=ignoreboth
# 设置退出 shell 时，当前 shell 中的最后多少行命令被写入历史记录文件
HISTSIZE=20000
# 设置历史记录文件中可以存储多少行命令
HISTFILESIZE=20000

# 追加历史记录而不是覆盖
shopt -s histappend
# 执行每个命令后检查窗口大小并且在必要时更新行数和列数
shopt -s checkwinsize
# 当只输入目录并会车时执行对应的 cd 命令
shopt -s autocd

# 启用补全
if [[ -n $IsOSX ]]; then
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"
elif ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# 补全时忽略大小写
bind "set completion-ignore-case on"

# 设置提示符
# 要想让 git 相关的提示正常需要安装并启动 bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
if [ -n "$(lsb_release -d | grep Manjaro)" ]; then
    if [ -s /usr/share/git/completion/git-prompt.sh ]; then
        source /usr/share/git/completion/git-prompt.sh
    fi
fi
#GIT_PS1_SHOWCOLORHINTS=1
PS1='$(
if [[ $? == 0 ]]; then
    echo -n "\[\e[1;32m\]:)";
else
    echo -n "\[\e[1;31m\]:(";
fi
) \u@\H \D{(%c)}\n\[\e[1;36m\]\w\[\e[1;33m\]$(__git_ps1 " (%s)") $(
if [[ ${EUID} == 0 ]]; then
    echo -n "\[\e[1;31m\]";
else
    echo -n "\[\e[1;36m\]";
fi
)\$ \[\e[0m\]'

# 设置别名
alias grep='grep --color=auto'
if [[ -n $IsOSX ]]; then
    alias ll='gls -ahlF --color=auto'
    alias la='gls -AF --color=auto'
    alias ls='gls -F --color=auto'
    alias l='ls'
else
    alias ll='ls -ahlF --color=auto'
    alias la='ls -AF --color=auto'
    alias ls='ls -F --color=auto'
    alias l='ls'
fi
alias info='info --vi-keys'
alias en='export LANG=en_US.UTF-8 && export LANGUAGE=en_US'
alias zh='export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if [[ -z $IsOSX ]]; then
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
fi

alias gl='git log'
alias glr='git log --graph'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gaa='git add .'
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
alias gt='git tag'
alias gta='git tag -a'
alias gcp='git cherry-pick'

# 拉取上游仓库 origin 中 master 分支的更新
# 推送到自己的仓库 ri 中 master 分支
# 用于更新自己 fork 的仓库到上游版本
# 此行为类似 follow，故而命名为 gf
#gf() {
#    current_branch="$(git branch | grep "\\*" | cut -b 3-)"
#    echo "Current branch is: $current_branch"
#    echo "Fetch master from the remote: origin"
#    git fetch --tags origin master
#    echo "Fetch done"
#    if [[ x"master" != x${current_branch} ]]; then
#        git checkout master || return $?
#    fi
#    git merge FETCH_HEAD || return $?
#    git push ri master || return $?
#    if [[ x"master" != x${current_branch} ]]; then
#        git checkout "${current_branch}" || return $?
#    fi
#}

alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'

# Gerrit git review function
#gr() {
#    branch_array=($(git branch | cut -b 3-))
#
#    index=1
#    for branch in "${branch_array[@]}"; do
#        if [[ $branch == master ]]; then
#            echo "[$index] $branch"
#        else
#            echo " $index  $branch"
#        fi
#        index=$(expr $index + 1)
#    done
#
#    echo -n "specify a branch to review: "
#    read selected_index
#
#    # default branch is master
#    if [[ -z $selected_index ]]; then
#        echo "review to branch master:"
#        git review -r origin master
#        return $?
#    fi
#
#    selected_branch=${branch_array[$selected_index]}
#    if [[ -n $selected_branch ]]; then
#        echo "review to branch $selected_branch: "
#        git review -r origin $selected_branch
#        return $?
#    else
#        echo "Error: specified branch can not find!";
#    fi
#}

alias grm='git rebase master'
# git rebase master function
#grm() {
#    flag=$(git branch | grep "\\* dev/")
#    if [[ -n $flag ]]; then
#        echo "Warning: rebase master in dev branch!"
#        echo "use complete command 'git rebase master' if you really want to do this!"
#    else
#        git rebase master
#    fi
#}

alias sss='svn status'
alias sup='svn update'
alias sad='svn add'
alias scm='svn commit'

alias m='make -j4'
alias mk='make'

alias dd='dd status=progress'

alias hr='history -r'
alias hw='history -w'
alias hi='history -r'
alias ho='history -w'

if [[ -z $IsOSX ]]; then
    alias o='xdg-open'
fi

alias http-proxy-set='export http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081; echo "http(s) proxy has been set to http://127.0.0.1:1081"'
alias http-proxy-set-wsl="export http_proxy=http://$WSLHOST:1080 https_proxy=http://$WSLHOST:1080; echo \"http(s) proxy has been set to http://$WSLHOST:1080\""
alias http-proxy-unset='unset http_proxy https_proxy'

alias man-en='LANG=en_US.UTF-8 man'

# 让所有 alias 支持 bash 补全
if [[ -f "$HOME/.bash_completion_alias" ]]; then
    source "$HOME"/.bash_completion_alias
    if [[ -n $IsOSX ]]; then
        aliasArray=($(alias | /usr/local/opt/gnu-sed/libexec/gnubin/sed -e '{s/alias //;s/=.*//}'))
    else
        aliasArray=($(alias | sed -e '{s/alias //;s/=.*//}'))
    fi
    for ali in "${aliasArray[@]}"; do
        complete -F _complete_alias "$ali"
    done
fi

# 设置有颜色的 man 手册
man() {
    env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;41;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    man "$@"
}

man-table-of-contents() {
    if [[ -z $1 ]]; then
        echo "which man-page do you want to get table of contents?"
        return 255
    fi
    env LANG=en_US.UTF-8 man "$1" | grep -P "^[A-Z]|^   [A-Z]"
}

# 设置其他环境变量
export EDITOR=vim

# java
#export JAVA_HOME=/usr/lib/jvm/default
#export JRE_HOME=$JAVA_HOME/jre
#export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#export PATH=$JAVA_HOME/bin:$PATH
unset _JAVA_OPTIONS

# android
#export ANDROID_HOME=$HOME/android-sdk-linux
#export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# golang
if [[ $IsOSX ]]; then
    export GOROOT=/usr/local/opt/go/libexec
else
    if [[ -d /usr/lib/go ]]; then
        export GOROOT=/usr/lib/go
    else
        export GOROOT=/opt/go
    fi
fi
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# node
export PATH=/opt/node/bin:$PATH

if [[ -f "$HOME/.cocos2d-x-env" ]]; then
    source "$HOME/.cocos2d-x-env"
fi
