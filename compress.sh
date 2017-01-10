#!/bin/bash

# compress all *.jpg files
# copy original files into the new directory with postfix '-original'

# case insensitive
# shopt -s nocaseglob

INPUT_PATH=""
OUTPUT_PATH=""
PREFIX="[original]"

# set flags
while getopts "d:" OPTION
do
  case $OPTION in
    d)
      INPUT_PATH="$OPTARG" ;;
    \?)
      echo "Used for the help menu" exit ;;
  esac
done

if [ -z "$INPUT_PATH" ]; then
  INPUT_PATH=$PWD
fi

cd "$INPUT_PATH"
OUTPUT_PATH="$PWD $PREFIX"

# create a backup
echo "Copying [$INPUT_PATH]"
rsync -a --info=progress2 "$INPUT_PATH/" "$OUTPUT_PATH"

#
# Compress all jpeg images in directory
# param1 - path to img that need to be compressed
#
function compressFolders() {
  in_path="$1"
  echo "Starting compressing $in_path folder... "

  for file in "$in_path"/*; do
    if [ -d "$file" ]; then
        echo ""
        echo "checking parent directory"
        echo "$file"
        echo ""
        compressFolders "$file"
    elif [ -f "$file" ]; then
        filename=$(basename "$file")
        extension="${filename##*.}"

        case "${extension^^}" in
          "JPG" | "JPEG")
            jpegoptim -o -m75 -p "$file"
            ;;
        esac
    fi
  done
}

# run compressing
compressFolders "$INPUT_PATH"
