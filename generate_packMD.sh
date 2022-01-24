#!/usr/bin/env bash

REPONAME="kaistall-pac"

echo -n "Generating markdown-file..."

echo "## Packages in repo" > Packages.md

for package in $(pacman -Sl ${REPONAME} | awk '{print $2}')
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
			echo "" >> Packages.md
			echo "| $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			echo "|---------------------|" >> Packages.md
			}
		;;
		Version*)
		[[ $PRINT = "YES" ]] && {
			echo "| Version: $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			}
		;;
		Descr*)
		[[ $PRINT = "YES" ]] && {
			echo "| $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			}
		;;
		URL*)
		[[ $PRINT = "YES" ]] && {
			echo "| $(echo ${line} | awk '{print $3}') |" >> Packages.md
			}
		;;
		License*)
		[[ $PRINT = "YES" ]] && {
			echo "| Licenses: $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			}
		;;
		Download*)
		[[ $PRINT = "YES" ]] && {
			echo "| Download size: $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			}
		;;
		Installed*)
		[[ $PRINT = "YES" ]] && {
			echo "| Installed size: $(echo ${line} | awk -F: '{print $2}') |" >> Packages.md
			}
		;;

	esac
	done < <(LANG=en_US.UTF-8 pacman -Si "$package" | awk '/Repos|Name|Version|Description|URL|Licenses|Download Size|Installed Size/')
done

echo " "
echo "DONE!"


