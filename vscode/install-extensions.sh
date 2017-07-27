#!/bin/bash

for VARIANT in "code" \
               "code-insiders"
do
  if hash $VARIANT 2>/dev/null; then
    echo "Installing extensions for $VARIANT"
    while read EXTENSION; do
    $VARIANT --install-extension $EXTENSION
    done <./vscode/extensions.list
  fi
done