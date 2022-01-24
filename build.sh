#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

for AUR_GIT in $(cat "${SCRIPTPATH}/BUILDLIST")
do
	PK_NAME=${AUR_GIT/https:\/\/aur.archlinux.org\//}
	PK_NAME=${PK_NAME/.git/}
	cd "${SCRIPTPATH}/PKGBUILDS/"
	[[ -d "${PK_NAME}" ]] && {
		cd ${PK_NAME}
		package=$(echo $(cat PKGBUILD | awk -F= '/^pkgname|^pkgver|^pkgrel/ {print $2}'))
		package=${package// /-}
		[[ -f "${SCRIPTPATH}/x86_64/${package}-x86_64.pkg.tar.zst" ]] && {
			echo  "${package}, has already been built - Skipping!"
		} || {
			[[ -f "${SCRIPTPATH}/.firsttime" ]] && {
				extra-x86_64-build
				rm ${SCRIPTPATH}/.firsttime
			} || {
				makechrootpkg -n -r /var/lib/archbuild/extra-x86_64
			}
		}
	} || {
	  	echo "${PK_NAME} not found!"
	  	echo "Seems you forgot to run get_builds.sh"
	  	exit 1
	}
	
done
