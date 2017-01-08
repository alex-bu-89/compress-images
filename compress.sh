#!/bin/bash

# case insensitive
shopt -s nocaseglob

IMG_PATH=""
OUTPUT_PATH=""

# set flags
while getopts "d:" OPTION
do
  case $OPTION in
    d)
      IMG_PATH="$OPTARG" ;;
    \?)
      echo "Used for the help menu" exit ;;
  esac
done

if [ -z "$IMG_PATH" ]; then
  IMG_PATH=$PWD
fi

# set current path
CURR_DIR=$(basename "$IMG_PATH")

# create output folder
cd "$IMG_PATH"
OUTPUT_PATH="$PWD [compressed]"
mkdir "$OUTPUT_PATH"

#
# Compress all jpeg images in directory. Copy videos if exist
#
function compressFolder {
  echo "Starting to compress $1 folder... "
  echo "------"

  for file in "$1"/*
  do
    filename=$(basename "$file")
    extension="${filename##*.}"

    case "${extension^^}" in

      # compress .jpg, ^^ = to upper case
      "JPG" | "JPEG")
        jpegoptim -o -m75 -d "$2" "$file"
        ;;

      # copy videos if exist
      "MOV")
        cp "$file" "$OUTPUT_PATH"
        echo "$filename [copied to] $OUTPUT_PATH"
        ;;

    esac
  done
}

# start compression
compressFolder "$IMG_PATH" "$OUTPUT_PATH"
