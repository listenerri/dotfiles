##########################################################
# 如果是非交互式 shell 则直接退出
##########################################################

[[ $- != *i* ]] && return
case $- in
    *i*) ;;
      *) return;;
esac


##########################################################
# bash 选项
##########################################################

# 追加历史记录而不是覆盖
shopt -s histappend
# 执行每个命令后检查窗口大小并且在必要时更新行数和列数
shopt -s checkwinsize
# 当只输入目录并会车时执行对应的 cd 命令
shopt -s autocd
# 补全时忽略大小写
bind "set completion-ignore-case on"


##########################################################
# bash 环境变量
##########################################################

export PATH=$HOME/bin:$HOME/.local/bin:$PATH
# 不把重复的行和空格开头的行加入历史记录
export HISTCONTROL=ignoreboth
# 设置退出 shell 时，当前 shell 中的最后多少行命令被写入历史记录文件
export HISTSIZE=20000
# 设置历史记录文件中可以存储多少行命令
export HISTFILESIZE=20000
# PROMPT_COMMAND 的内容会在每次执行命令后都执行
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"


##########################################################
# 设置别名
##########################################################

alias grep='grep --color=auto'
alias ll='ls -ahlF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -F --color=auto'
alias l='ls'
alias info='info --vi-keys'
alias en='export LANG=en_US.UTF-8 && export LANGUAGE=en_US'
alias zh='export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gc='git commit'
alias gca='git commit --amend'
alias gch='git checkout'
alias gcm='git checkout master'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdm='git diff master'
alias gl='git log'
alias glr='git log --graph'
alias gpl='git pull'
alias gps='git push'
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias grm='git rebase master'
alias gs='git status'
alias gsl='git stash list'
alias gsi='git stash push'
alias gso='git stash pop'
alias gsd='git stash drop'
alias gss='git stash show -p'
alias gt='git tag'
alias gta='git tag -a'

alias sss='svn status'
alias sup='svn update'
alias sad='svn add'
alias scm='svn commit'

alias m='make -j4'
alias mk='make'

alias dd='dd status=progress'

alias hr='history -n'
alias hw='history -a'
alias hi='history -n'
alias ho='history -a'

alias o='xdg-open'
if [[ -n $WSL_DISTRO_NAME || -n $MSYSTEM ]]; then
    alias o='explorer.exe'
fi

alias man-en='LANG=en_US.UTF-8 man'
alias man-zh='LANG=zh_CN.UTF-8 man'

# 让所有 alias 支持 bash 补全
if [[ -f "$HOME/.bash_completion_alias" ]]; then
    source "$HOME"/.bash_completion_alias
    aliasArray=($(alias | sed -e '{s/alias //;s/=.*//}'))
    for ali in "${aliasArray[@]}"; do
        complete -F _complete_alias "$ali"
    done
fi


##########################################################
# 设置提示符
##########################################################

# 要想让 git 相关的提示正常需要安装并启动 bash-completion
if [[ "$(type -t __git_ps1)" != "function" ]]; then
    if [[ -f /usr/share/git/git-prompt.sh ]]; then
        source /usr/share/git/git-prompt.sh
    elif [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
        source /usr/share/git/completion/git-prompt.sh
    elif [[ -f $HOME/dotfiles/git-prompt.sh ]]; then
        source $HOME/dotfiles/git-prompt.sh
    fi
fi
if [[ "$(type -t __git_ps1)" == "function" ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    #GIT_PS1_SHOWCOLORHINTS=1
    PS1='$(
    retCode=$?
    if [[ $retCode == 0 ]]; then
        echo -n "\[\e[1;32m\]:)";
    else
        echo -n "\[\e[1;31m\]:( [$retCode]";
    fi
    unset retCode
    ) \u@\H \D{(%Y%m%d-%H%M%S)} $(
    if [[ -n $MSYSTEM ]]; then
        echo -n "\[\e[1;35m\]$MSYSTEM";
    fi
    )\012\[\e[1;36m\]\w\[\e[1;33m\]$(
    if [[ -z $MSYSTEM ]]; then
        __git_ps1 " (%s)"
    fi
    if [[ ${EUID} == 0 ]]; then
        echo -n "\012\[\e[1;31m\]\$\[\e[0m\] ";
    else
        echo -n "\012\[\e[1;36m\]\$\[\e[0m\] ";
    fi
    )'
fi


##########################################################
# 函数定义
##########################################################

# man 手册支持颜色
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
# man 手册章节
man-table-of-contents() {
    if [[ -z $1 ]]; then
        echo "which man-page do you want to get table of contents?"
        return 255
    fi
    env LANG=en_US.UTF-8 man "$1" | grep -P "^[A-Z]|^   [A-Z]"
}
# 设置代理
http-proxy-set() {
    proxy_addr_default=127.0.0.1
    proxy_port_default=1080
    echo -n "please input proxy addr(default is $proxy_addr_default): "
    read proxy_addr
    echo -n "please input proxy port(default is $proxy_port_default): "
    read proxy_port
    if [[ -z $proxy_addr ]]; then
        proxy_addr=$proxy_addr_default
    fi
    if [[ -z $proxy_port ]]; then
        proxy_port=$proxy_port_default
    fi
    proxy_server=http://$proxy_addr:$proxy_port
    echo "setting http proxy server: $proxy_server"
    export http_proxy=$proxy_server https_proxy=$proxy_server
    unset proxy_addr_default proxy_port_default proxy_addr proxy_port proxy_server
}
# 取消代理
http-proxy-unset() {
    unset http_proxy https_proxy
}


##########################################################
# autojump
##########################################################

if [ -s $HOME/.autojump/share/autojump/autojump.bash ]; then
    source $HOME/.autojump/share/autojump/autojump.bash
elif [ -s /usr/local/share/autojump/autojump.bash ]; then
    source /usr/local/share/autojump/autojump.bash
elif [ -s /usr/share/autojump/autojump.bash ]; then
    source /usr/share/autojump/autojump.bash
fi


##########################################################
# bash_completion
##########################################################

if [ -f /usr/share/bash-completion/bash_completion ]; then
. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi


##########################################################
# tmux
##########################################################

# 修复 msys2 下 tmux 的相关问题
if [[ -n "$MSYSTEM" ]]; then
    # 修复 windows-terminal 上使用 msys2 tmux 无法启动
    if [[ -n "$WT_SESSION" ]]; then
        function tmux() {
            # 先将参数赋值到临时变量，否则直接在后续命令中展开会丢失参数
            ARGS="$@"
            # 修复 msys2 下 tmux 启动慢
            # https://github.com/tmux/tmux/issues/3428
            pgrep tmux > /dev/null 2>&1 || rm -rf "/tmp/tmux-${UID}/default"
            script -q -c "command tmux $ARGS" /dev/null
            unset ARGS
        }
    else
        function tmux() {
            # 先将参数赋值到临时变量，否则直接在后续命令中展开会丢失参数
            ARGS="$@"
            # 修复 msys2 下 tmux 启动慢
            # https://github.com/tmux/tmux/issues/3428
            pgrep tmux > /dev/null 2>&1 || rm -rf "/tmp/tmux-${UID}/default"
            command tmux $ARGS
            unset ARGS
        }
    fi
fi
alias t=tmux


##########################################################
# 其他设置
##########################################################

# 默认编辑器
export EDITOR=vim

# golang
if [[ -d /usr/lib/go ]]; then
    export GOROOT=/usr/lib/go
else
    export GOROOT=/opt/go
fi
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# cocos2d-x
if [[ -f "$HOME/.cocos2d-x-env" ]]; then
    source "$HOME/.cocos2d-x-env"
fi

# nodejs nvm
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# rust
if [[ -f $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

# opencode
export PATH=/home/ri/.opencode/bin:$PATH

# uv autocompletion
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"

