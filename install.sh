#!/usr/bin/env bash

IsOSX=$(uname -a | grep -i Darwin)

if [[ $IsOSX ]]; then
    if [[ -z $(which realpath) ]]; then
        echo "require realpath command!"
        exit -1
    fi

    if [[ -z $(shopt | grep autocd) ]]; then
        echo "require install another version of bash using brew!"
        exit -1
    fi
fi

DotFilesDir=$(dirname $(realpath $0))
echo "current dot files directory is: $DotFilesDir"

echo "update submodules..."
cd $DotFilesDir
git submodule init
git submodule update

install_pam_env_dot_files() {
    echo "install for pam environment..."
    ln -s -f $DotFilesDir/pam_environment $HOME/.pam_environment
}

install_bash_dot_files() {
    rm -rf $HOME/.bashrc $HOME/.bash_profile $HOME/.bash_logout $HOME/.bash_completion_alias $HOME/.profile
    echo "install for bash..."
    ln -s -f $DotFilesDir/bashrc $HOME/.bashrc
    ln -s -f $DotFilesDir/bash_profile $HOME/.bash_profile
    ln -s -f $DotFilesDir/bash_logout $HOME/.bash_logout
    ln -s -f $DotFilesDir/libs/complete-alias/bash_completion.sh $HOME/.bash_completion_alias
}

install_conky_dot_files() {
    rm -rf $HOME/.conky.conf
    echo "install for conky..."
    ln -s -f $DotFilesDir/conky.conf $HOME/.conky.conf
}

install_gdb_dot_files() {
    rm -rf $HOME/.gdbinit $HOME/.config/gdb/qt5printers
    echo "install for gdb..."
    mkdir -p $HOME/.config/gdb
    ln -s -f $DotFilesDir/gdbinit $HOME/.gdbinit
    ln -s -f $DotFilesDir/libs/qt5printers $HOME/.config/gdb/qt5printers
}

install_git_dot_files() {
    rm -rf $HOME/.config/git/config $HOME/.config/git/ignore
    echo "install for git..."
    mkdir -p $HOME/.config/git
    ln -s -f $DotFilesDir/git-config $HOME/.config/git/config
    ln -s -f $DotFilesDir/git-ignore $HOME/.config/git/ignore
}

install_qtcreator_dot_files() {
    rm -rf $HOME/.config/QtProject/qtcreator/snippets/snippets.xml
    echo "install for qtcreator..."
    mkdir -p $HOME/.config/QtProject/qtcreator/snippets
    ln -s -f $DotFilesDir/qtcreator/snippets.xml $HOME/.config/QtProject/qtcreator/snippets/snippets.xml
}

install_tmux_dot_files() {
    rm -rf $HOME/.tmux.conf
    echo "install for tmux..."
    ln -s -f $DotFilesDir/tmux.conf $HOME/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_nautilus_scripts() {
    echo "install for nautilus scripts..."
    nautilus_scripts_dir=$HOME/.local/share/nautilus/scripts/
    mkdir -p $nautilus_scripts_dir
    ln -s -f $DotFilesDir/nautilus/* $nautilus_scripts_dir
}

install_pam_env_dot_files
install_bash_dot_files
install_conky_dot_files
install_gdb_dot_files
install_git_dot_files
install_qtcreator_dot_files
install_tmux_dot_files
install_nautilus_scripts
