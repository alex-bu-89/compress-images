#!/bin/bash
shopt -s nocaseglob # case insensitive
IMG_PATH=$1

if [ -z "$IMG_PATH" ]; then
  IMG_PATH=$PWD
fi

echo "Starting to compress $IMG_PATH folder..."

for img in "$IMG_PATH"/*.JPG
do
  jpegtran -optimize -progressive -outfile $img
done
