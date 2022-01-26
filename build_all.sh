#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

for AUR_PKG in $(cat "${SCRIPTPATH}/BUILDLIST")
do
cd ${SCRIPTPATH}/scripts
./build_package.sh ${AUR_PKG}
[[ $? = 0 ]] || exit 1
done
