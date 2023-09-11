#!/usr/bin/env bash

# Maintenance script for macOS
# This script cleans up various caches, temporary files, and other cruft on macOS.
# Custom script (forked from https://github.com/paulaime/CleanUpMac)
# -- STEPS ---
# Download/update the script: curl https://raw.githubusercontent.com/nodejs/build/main/tools/macos-cleanup.sh --output macos-cleanup.sh
# Make the script executable: chmod +x macos-cleanup.sh
# Usage: sudo ./macos-cleanup.sh

# Ask for the administrator password upfront
if [ "$EUID" -ne 0  ]; then
    echo "Please run as root"
    exit
fi


echo 'Empty the Trash on all mounted volumes and the main HDD…'
sudo rm -rfv /Volumes/*/.Trashes &>/dev/null
sudo rm -rfv ~/.Trash &>/dev/null

echo 'Clear System Log Files…'
sudo rm -rfv /private/var/log/asl/*.asl &>/dev/null
sudo rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
sudo rm -rfv /Library/Logs/Adobe/* &>/dev/null
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

echo 'Clear Adobe Cache Files…'
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

echo 'Cleanup iOS Applications…'
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

echo 'Remove iOS Device Backups…'
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

echo 'Cleanup XCode Derived Data and Archives…'
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null

echo 'Cleanup Homebrew Cache…'
brew cleanup --force -s &>/dev/null
brew cask cleanup &>/dev/null
rm -rfv /Library/Caches/Homebrew/* &>/dev/null
brew tap --repair &>/dev/null

echo 'Cleanup MacOS Application caches'
rm -rfv /System/Library/Caches/*

echo 'Cleanup any old versions of gems…'
gem cleanup &>/dev/null

echo 'Purge inactive memory…'
sudo purge