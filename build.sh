#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <release-tarball-url>"
    exit 1
fi

URL="$1"
ARCHIVE="release.tar.gz"
PROJECT_DIR="whisper.cpp"

echo "Downloading release tarball..."
curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting archive..."
mkdir -p source
tar -xf "$ARCHIVE" -C source

rm "$ARCHIVE"

# Find the extracted project directory
SOURCE_DIR=$(find source -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Could not find extracted source directory."
    exit 1
fi

cd "$SOURCE_DIR"

echo "Configuring build..."
cmake -B build -DCMAKE_BUILD_TYPE=Release

echo "Building..."
cmake --build build -j --config Release

echo "Finishing..."
mkdir -p output
cp ./build/bin/* ./output/

echo "Done!"
