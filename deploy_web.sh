#!/bin/bash
WEB_BUILD_DIR="./build/web"
DEST_DIR="./docs"

# Build web version
flutter clean
flutter build web
rm -r "$DEST_DIR"
mkdir "$DEST_DIR"
mv "$WEB_BUILD_DIR"/* "$DEST_DIR"