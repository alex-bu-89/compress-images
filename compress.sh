#!/bin/bash

# compress all *.jpg files
# and place them in the new directory with postfix '-compressed'
# with the same modification date as original files.

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

# stop script if directory doesn't exist
if [ ! -d "$IMG_PATH" ]; then
  echo "Directory [$IMG_PATH] doesn't exist"
  exit
fi

# set current path
CURR_DIR=$(basename "$IMG_PATH")

# create output folder
cd "$IMG_PATH"
OUTPUT_PATH="$PWD [compressed]"
mkdir "$OUTPUT_PATH"

#
# Compress all jpeg images in directory. Copy videos if exist
# param1 - path to compress
# param2 - output path
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
        jpegoptim -o -m75 -d "$2" -p "$file"
        ;;

      # copy videos if exist
      "MOV")
        cp "$file" "$2"
        echo "$filename [copied to] $2"
        ;;

    esac
  done
}

#
# Compress child folder
#
# function recurse {
#  for i in "$1"/*; do
#     if [ -d "$i" ]; then
#         echo "dir: $i"
#         recurse "$i"
#     elif [ -f "$i" ]; then
#         echo "file: $i"
#     fi
#  done
# }

# start compression
compressFolder "$IMG_PATH" "$OUTPUT_PATH"
