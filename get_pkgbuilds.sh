#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/scripts/utils.sh

ADDED=""
UPDATED=""
UPTODATE=""

for AUR_PKG in $(cat "${SCRIPTPATH}/BUILDLIST")
do
cd "${SCRIPTPATH}/PKGBUILDS/"
	[[ -d "${AUR_PKG}" ]] && {
		cd ${AUR_PKG}
	  	IS_IT=$(git pull)
		[[ "$IS_IT" = "Already up to date." ]] && {
			UPTODATE="${UPTODATE} ${AUR_PKG}" 
		} || {
			UPDATED="${UPDATED} ${AUR_PKG}"
		}
 	} || {
 		AUR_GIT="https://aur.archlinux.org/${AUR_PKG}.git"
	 	IS_IT=$(git clone ${AUR_GIT})
		ADDED="${ADDED} ${AUR_PKG}"
	}
done

[[ -z "${ADDED}" ]] || {
	cd ${SCRIPTPATH}
	echo -e "$(c +B)Pushing changes to git ..$(c -B)"
	git add --all .
	git commit -m "Added new packages: ${ADDED}"
	git push -u origin main
}
echo ""
echo ""
[[ -z "${UPTODATE}" ]] || echo -e "$(c +B)ALREADY UP TO DATE:$(c -B)\n${UPTODATE}\n\n"
[[ -z "${UPDATED}" ]] || echo -e "$(c +B)UPDATED:$(c -B)\n${UPDATED}\n\n"
[[ -z "${ADDED}" ]] || echo -e "$(c +B)NEWLY ADDED:$(c -B)\n${ADDED}\n\n"
