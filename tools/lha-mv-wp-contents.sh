#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)  # absolute path of the script directory

SRC="./wp-content/uploads"
DEST_IMG="./wp-content/images"
DEST_RES="./wp-content/resources"

mkdir -p "$DEST_IMG" "$DEST_RES" 

for f in $(${SCRIPT_DIR}/lha-ls-wp-contents-images.sh "$*") ; do
  echo mv "$SRC/$f" "$DEST_IMG/$f"
  mv "$SRC/$f" "$DEST_IMG/$f"
done
for f in $(${SCRIPT_DIR}/lha-ls-wp-contents-resources.sh "$*") ; do
  echo mv "$SRC/$f" "$DEST_RES/$f"
  mv "$SRC/$f" "$DEST_RES/$f"
done
