#!/usr/bin/env bash

# Build the Flutter app and package into an archive.

set -e
set -x

projectName=ApplinksFlatpak

archiveName=$projectName-Linux-Portable.tar.gz
baseDir=$(pwd)

# ----------------------------- Build Flutter app ---------------------------- #


flutter pub get
flutter build linux --verbose -t lib/main.dart  --build-number "$BUILD_NUMBER" --build-name "$BUILD_NAME"

cd build/linux/x64/release/bundle || exit
tar -czaf $archiveName ./*
mv $archiveName "$baseDir"/
