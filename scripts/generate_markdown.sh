#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/utils.sh

Qpath="$( cd -- "${SCRIPTPATH}/.." >/dev/null 2>&1 ; pwd -P )"


REPONAME="kaistall-pac"

echo -e "$(c +B)Generating markdown-file.. $(c -B)."

echo "## Packages in repo" > ${Qpath}/Packages.md

sudo pacman --config ${SCRIPTPATH}/pacman.conf -Syy

for package in $(pacman --config ${SCRIPTPATH}/pacman.conf -Sl ${REPONAME} | awk '{print $2}')
do
	while read -r line
	do
	echo -n "."
	case "$line" in
		Repos*)
		if [[ "$line" == *${REPONAME} ]] ; then
			PRINT="YES"
		else 
			PRINT="NO"
		fi
		;;
		Name*)
		[[ $PRINT = "YES" ]] && {
			echo "" >> ${Qpath}/Packages.md
			echo "| $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			echo "|---------------------|" >> ${Qpath}/Packages.md
			}
		;;
		Version*)
		[[ $PRINT = "YES" ]] && {
			echo "| Version: $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			}
		;;
		Descr*)
		[[ $PRINT = "YES" ]] && {
			echo "| $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			}
		;;
		URL*)
		[[ $PRINT = "YES" ]] && {
			echo "| $(echo ${line} | awk '{print $3}') |" >> ${Qpath}/Packages.md
			}
		;;
		License*)
		[[ $PRINT = "YES" ]] && {
			echo "| Licenses: $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			}
		;;
		Download*)
		[[ $PRINT = "YES" ]] && {
			echo "| Download size: $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			}
		;;
		Installed*)
		[[ $PRINT = "YES" ]] && {
			echo "| Installed size: $(echo ${line} | awk -F: '{print $2}') |" >> ${Qpath}/Packages.md
			}
		;;

	esac
	done < <(LANG=en_US.UTF-8 pacman --config ${SCRIPTPATH}/pacman.conf -Si "$package" | awk '/Repos|Name|Version|Description|URL|Licenses|Download Size|Installed Size/')
done

sudo pacman -Syy

echo " "
echo -e "$(c +G)DONE!$(c -G)"


