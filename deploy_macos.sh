#!/bin/bash

BUILD_PATH="./build/macos/Build/Products/Release/duo_words.app"

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Remove previous installation
sudo rm -rf "/Applications/duo_words.app"

# Build
flutter clean
flutter build ios
flutter build macos

# Install
sudo cp $BUILD_PATH "/Applications/"