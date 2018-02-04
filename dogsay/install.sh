#!/bin/bash

if python --version &> /dev/null; then
    now=$(date +"%s")
    cwd=$(pwd)
    version="1.0.0"
    rm -rf $HOME/.dogsay
    mkdir -p $HOME/.dogsay/bin
    cd $HOME
    mkdir dogsay_$now
    cd dogsay_$now
    curl -fsLo dogsay.tar.gz https://benbotvinick.com/projects/dogsay/dogsay-$version.tar.gz
    tar -xzpf dogsay.tar.gz
    rm dogsay.tar.gz
    mv dogsay/dogsay $HOME/.dogsay/bin/dogsay
    mv dogsay/dogsay.py $HOME/.dogsay/dogsay.py
    mv dogsay/update.sh $HOME/.dogsay/update.sh
    touch $HOME/.dogsay/VERSION
    echo "Dogsay $version" > $HOME/.dogsay/VERSION
    tput bold
    printf "Enter the path to your config file (.bashrc, .profile, etc.): "
    tput sgr0
    read config
    if cat $HOME/$config &> /dev/null; then
        if ! grep -Fxq "export PATH=\"\$PATH:\$HOME/.dogsay/bin\"" $HOME/$config; then
            echo "" >> $HOME/$config
            echo "# Add Dogsay to path. Removing this line will depricate the Dogsay command." >> $HOME/$config
            echo "export PATH=\"\$PATH:\$HOME/.dogsay/bin\"" >> $HOME/$config
        fi
        touch dogsay/update_path.sh
        echo "#!$SHELL" >> dogsay/update_path.sh
        echo "source \$1" >> dogsay/update_path.sh
        $SHELL dogsay/update_path.sh $HOME/$config
        rm dogsay/update_path.sh
        tput bold
        tput setaf 2
        echo "Successfully installed Dogsay $version."
    else
        tput bold
        tput setaf 1
        echo "Installation failed. Perhaps you entered an invalid path. Try again with a new config file."
        tput sgr0
        rm -rf $HOME/.dogsay
    fi
    cd ..
    rm -rf dogsay_$now
    cd $cwd
else
    tput bold
    tput setaf 1
    echo "Installation failed because you don't have Python. Please install Python and try again."
    tput sgr0
fi
