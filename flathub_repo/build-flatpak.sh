#!/usr/bin/env bash
# Convert the archive of the Flutter app to a Flatpak.

set -e # Exit if any command fails
set -x # Echo all commands for debug purposes


# Project variables - no spaces allowed
projectName=ApplinksFlatpak # Same as project-name in build_flatpak.yml
projectId=com.llfbandit.example # The same as app-id as in com.llfbandit.example.yml
executableName=$(grep -Po 'set\(BINARY_NAME "\K[^"]*' CMakeLists.txt) # Read from CMakeLists.txt
  
# ------------------------------- Build Flatpak ----------------------------- #\

# Extract portable Flutter build.
mkdir -p $projectName
tar --no-same-owner -xf $projectName-Linux-Portable.tar.gz -C $projectName

# Copy the portable app to the Flatpak-based location.
cp -r $projectName /app/
chmod +x /app/$projectName/"$executableName"
mkdir -p /app/bin
ln -s /app/$projectName/"$executableName" /app/bin/"$executableName"

# Install the icon.
iconDir=/app/share/icons/hicolor/scalable/apps
mkdir -p $iconDir
iconFileName=com.llfbandit.example.png
cp -r ./$iconFileName $iconDir/

# Install the desktop file.
desktopFileDir=/app/share/applications
mkdir -p $desktopFileDir
cp -r packaging/linux/$projectId.desktop $desktopFileDir/$projectId.desktop

# Install the AppStream metadata file.
metadataDir=/app/share/metainfo
mkdir -p $metadataDir
metaInfoSrcFile="packaging/linux/$projectId.metainfo.xml"
cp -r $metaInfoSrcFile $metadataDir/
