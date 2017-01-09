#!/bin/bash

# compress all *.jpg files
# and place them in the new directory with postfix '-compressed'
# with the same modification date as original files.

# case insensitive
# shopt -s nocaseglob

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

#
# Compress child folder
#
function recurse {
  input_path="$1"
  output_path=""

  # create output folder
  cd "$input_path"
  output_path="$PWD [compressed]"
  mkdir "$output_path"

  for file in "$input_path"/*; do
    if [ -d "$file" ]; then
        echo ""
        echo "----------- checking parent directory"
        echo "$file"
        echo ""
        recurse "$file"
    elif [ -f "$file" ]; then
        echo "file: $file"
    fi
  done
}

recurse "$INPUT_PATH"
