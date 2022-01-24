#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

touch ${SCRIPTPATH}/.firsttime

for AUR_GIT in $(cat "${SCRIPTPATH}/BUILDLIST")
do
	PK_NAME=${AUR_GIT/https:\/\/aur.archlinux.org\//}
	PK_NAME=${PK_NAME/.git/}
	cd "${SCRIPTPATH}/PKGBUILDS/"
	[[ -d "${PK_NAME}" ]] && {
		cd ${PK_NAME}
		package="${PK_NAME}-$(echo $(cat PKGBUILD | awk -F= '/^pkgver=|^pkgrel=/ {print $2}'))"
		package=${package// /-}
			[[ -f "${SCRIPTPATH}/.firsttime" ]] && {
				extra-x86_64-build
				gpg --detach-sign ${SCRIPTPATH}/x86_64/${package}-*.pkg.tar.zst
				rm ${SCRIPTPATH}/.firsttime
			} || {
				makechrootpkg -n -r /var/lib/archbuild/extra-x86_64
				gpg --detach-sign ${SCRIPTPATH}/x86_64/${package}-*.pkg.tar.zst
			}
	} || {
	  	echo "${PK_NAME} not found!"
	  	echo "Seems you forgot to run get_builds.sh"
	  	exit 1
	}
	
done
