#!/usr/bin/env bash

echo "Installing Visual Studio code extensions and config."

code -v > /dev/null
if [[ $? -eq 0 ]];then
    read -r -p "Do you want to install VSC extensions? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        echo "Installing extensions please wait..."
        code --install-extension ms-vscode.atom-keybindings
        code --install-extension HookyQR.beautify
        code --install-extension dbaeumer.vscode-eslint
        code --install-extension mquandalle.graphql
        code --install-extension kumar-harsh.graphql-for-vscode
        code --install-extension stpn.vscode-graphql
        code --install-extension eg2.vscode-npm-script
        code --install-extension christian-kohler.npm-intellisense
        code --install-extension techer.open-in-browser
        code --install-extension remimarsal.prettier-now
        code --install-extension rebornix.ruby
        code --install-extension groksrc.ruby
        code --install-extension misogi.ruby-rubocop
        code --install-extension octref.vetur
        
        echo "Extensions for VSC have been installed. Please restart your VSC."
    else
        echo "Skipping extension install.";
    fi

    read -r -p "Do you want to overwrite user config? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        read -r -p "Do you want to back up your current user config? [Y|n] " backupresponse
        if [[ $backupresponse =~ ^(n|no|N) ]];then
            echo "Skipping user config save."
        else
            cp $HOME/Library/Application\ Support/Code/User/settings.json $HOME/Library/Application\ Support/Code/User/settings.backup.json
            echo "Your previous config has been saved to: $HOME/Library/Application Support/Code/User/settings.backup.json"
        fi
        cp ./settings.json $HOME/Library/Application\ Support/Code/User/settings.json

        echo "New user config has been written. Please restart your VSC."
    else
        echo "Skipping user config overwriting.";
    fi
else
    error "Please make sure you have Visual Studio Code installed"
fi