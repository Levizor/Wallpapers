#!/usr/bin/env zsh

# This script is used to select images to delete.
# It shows each image and waits for the user to press Enter or Space.
# If the user presses d, the image is marked for deletion.
# If the user presses Enter, the image is kept.
# Images to delete are written to delete_list

setopt extended_glob
setopt null_glob

DELETE_LIST="delete_list.txt"

img_files=(*.(jpg|png)(.N))  # jpg/png, non-hidden, no dirs

if [[ ${#img_files} -eq 0 ]]; then
  echo "No images found."
  exit 1
fi
echo "Found ${#img_files} images."


for img in $img_files; do
  clear
  echo "Showing: $img"
  timg "$img" </dev/tty >/dev/tty

  echo
  echo -n "[Enter/Space to keep, d to mark for delete] > " >/dev/tty
  read -k 1 key </dev/tty

  if [[ "$key" == "d" ]]; then
    echo "$img" >> "$DELETE_LIST"
    echo "\nMarked for deletion: $img" >/dev/tty
  else
    echo "\nKept: $img" >/dev/tty
  fi
done

echo "\nDone. Files marked for deletion:" >/dev/tty
cat "$DELETE_LIST"

