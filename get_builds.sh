#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

ADDED=""
UPDATED=""
UPTODATE=""

for AUR_GIT in $(cat "${SCRIPTPATH}/BUILDLIST")
do
	PK_NAME=${AUR_GIT/https:\/\/aur.archlinux.org\//}
	PK_NAME=${PK_NAME/.git/}
	cd "${SCRIPTPATH}/PKGBUILDS/"
	[[ -d "${PK_NAME}" ]] && {
		cd ${PK_NAME}
	  	IS_IT=$(git pull)
		[[ "$IS_IT" = "Already up to date." ]] && {
			UPTODATE="${UPTODATE} ${PK_NAME}" 
		} || {
			UPDATED="${UPDATED} ${PK_NAME}"
		}
 	} || {
	 	IS_IT=$(git clone ${AUR_GIT})
		ADDED="${ADDED} ${PK_NAME}"
	}
done
echo ""
echo ""
[[ -z "${UPTODATE}" ]] || echo -e "ALREADY UP TO DATE:\n${UPTODATE}\n\n"
[[ -z "${UPDATED}" ]] || echo -e "UPDATED:\n${UPDATED}\n\n"
[[ -z "${ADDED}" ]] || {
echo -e "NEWLY ADDED:\n${ADDED}\n\n"
 git add --all .
 git commit -m "Added new packages: ${ADDED}"
 git push -u origin main
}
echo ""
