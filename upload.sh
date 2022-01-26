#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/scripts/utils.sh

echo -e "$(c +B)Uploading new content to Github...$(c -B)"

git add --all .

git commit -m "Updated Repo"

git push -u origin main

echo "$(c +G)Done!$(c -G)"
