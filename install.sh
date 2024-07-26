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
    ln -s -f $DotFilesDir/libs/complete-alias/complete_alias $HOME/.bash_completion_alias
}

install_conky_dot_files() {
    rm -rf $HOME/.conky.conf
    echo "install for conky..."
    ln -s -f $DotFilesDir/conky.conf $HOME/.conky.conf
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

echo -n "install_pam_env_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_pam_env_dot_files
    else
	echo "not install it"
    fi
else
    install_pam_env_dot_files
fi

echo -n "install_bash_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_bash_dot_files
    else
	echo "not install it"
    fi
else
    install_bash_dot_files
fi

echo -n "install_conky_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_conky_dot_files
    else
	echo "not install it"
    fi
else
    install_conky_dot_files
fi

echo -n "install_git_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_git_dot_files
    else
	echo "not install it"
    fi
else
    install_git_dot_files
fi

echo -n "install_qtcreator_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_qtcreator_dot_files
    else
	echo "not install it"
    fi
else
    install_qtcreator_dot_files
fi

echo -n "install_tmux_dot_files: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_tmux_dot_files
    else
	echo "not install it"
    fi
else
    install_tmux_dot_files
fi

echo -n "install_nautilus_scripts: [Y/n]"
read isOK
if [[ -n "${isOK}" ]]; then
    if [[ "${isOK}" = "y" || "${isOK}" = "Y" ]]; then
        install_nautilus_scripts
    else
	echo "not install it"
    fi
else
    install_nautilus_scripts
fi

