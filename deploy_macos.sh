#!/bin/bash

BUILD_PATH="./build/macos/Build/Products/Release/duo_words.app"

# Remove previous installation
rm -rf "/Applications/duo_words.app"

# Build
flutter build macos

# Install
mv $BUILD_PATH "/Applications/"