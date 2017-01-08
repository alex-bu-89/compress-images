#!/bin/bash

# case insensitive
shopt -s nocaseglob

# set directory folder
IMG_PATH=$1
OUT_PATH="compressed"

if [ -z "$IMG_PATH" ]; then
  IMG_PATH=$PWD
fi

# start compression
echo "Starting to compress $IMG_PATH folder..."
mkdir $IMG_PATH/$OUT_PATH

for img in "$IMG_PATH"/*.jpg
do
  #jpegtran -optimize -progressive -outfile $img $img
  jpegoptim -o -m80 -d $IMG_PATH/$OUT_PATH $img
done
