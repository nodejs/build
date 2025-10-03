#!/bin/bash

set -e

XCODE_VERSION=$1

if [[ -n $DEBUG ]]; then
    set -x
fi

cd ~/Desktop
cp /Volumes/orka/Xcode/Xcode_${XCODE_VERSION}.xip ~/Desktop/Xcode.xip

if [ ! -d Xcode.app ]; then
    echo "Unpacking… This will take several minutes"
    xip --expand Xcode.xip
fi

if [ -d /Applications/Xcode.app ]; then
    echo "Removing old Xcode"
    rm -rf /Applications/Xcode.app
fi

echo "Moving new Xcode into place"
mv Xcode.app /Applications

sudo xcode-select -s /Applications/Xcode.app

echo "Accepting the license agreement"
sudo xcodebuild -license accept

echo "Installing internal packages to avoid the first launch prompt"
sudo xcodebuild -runFirstLaunch

sudo DevToolsSecurity -enable

rm -f Xcode.xip

echo "Done!"
