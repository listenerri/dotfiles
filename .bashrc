#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



##################Costom Config###################

# set for terminal prompt
PS1='$(if [[ $? == 0 ]]; then echo "\[\e[1;32m\]:) "; else echo "\[\e[1;31m\]:( "; fi)$(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\u "; else echo "\[\e[1;36m\]\u "; fi)$(echo "\[\e[1;32m\]\w ")$(if [[ -d .git ]]; then echo "\[\e[1;33m\](`git status | head -n 1 | grep -o "\b\S*$"`) "; fi)$(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\$ "; else echo "\[\e[1;36m\]\$ "; fi)\[\e[0m\]'

# alias
alias grep='grep --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -F --color=auto'
alias info='info --vi-keys'
alias en='export LANG=en_US.UTF-8 && export LANGUAGE=en_US'
alias zh='export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN'
alias ..='cd ..'

# Set colors for man pages
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

export EDITOR=vim

# set for java(arch linux)
export JAVA_HOME=/usr/lib/jvm/default
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
unset _JAVA_OPTIONS

# set for eclipse
export ECLIPSE_HOME=/usr/lib/eclipse

# set for android
export ANDROID_HOME=/home/ri/android-sdk-linux
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# set for oracle database
# oracle install path
export ORACLE_BASE=/home/ri/oracle_11gR2_database/ri
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
# oracle database sid
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl


export PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/sqldeveloper/sqldeveloper/bin/:/home/ri/shells
