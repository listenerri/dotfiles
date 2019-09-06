#!/bin/bash

IsOSX=$(uname -a | grep -i Darwin)
DotFilesDir=$(dirname $(readlink -e $0))
echo "current dot files directory is: $DotFilesDir"

echo "update submodules..."
cd $DotFilesDir
git submodule init
git submodule update

install_bash_dot_files() {
    rm -rf $HOME/.bashrc $HOME/.bash_profile $HOME/.bash_logout $HOME/.bash_completion_alias
    echo "install for bash..."
    if [[ $IsOSX ]]; then
        ln -s -f $DotFilesDir/bashrc-osx $HOME/.bashrc
    else
        ln -s -f $DotFilesDir/bashrc $HOME/.bashrc
    fi
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
}

install_vscode_dot_files() {
    rm -rf $HOME/.config/Code/User/settings.json $HOME/.config/Code/User/keybindings.json $HOME/.config/Code/User/snippets
    echo "install for vscode..."
    mkdir -p $HOME/.config/Code/User
    ln -s -f $DotFilesDir/vscode/settings.json $HOME/.config/Code/User/settings.json
    ln -s -f $DotFilesDir/vscode/keybindings.json $HOME/.config/Code/User/keybindings.json
    ln -s -f $DotFilesDir/vscode/snippets $HOME/.config/Code/User/snippets
}

install_bash_dot_files
install_conky_dot_files
install_gdb_dot_files
install_git_dot_files
install_qtcreator_dot_files
install_tmux_dot_files
install_vscode_dot_files
