#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/scripts/utils.sh

[[ -z $1 ]] && MESSAGE="Please fill out the form" || MESSAGE="${1}"
[[ -z $4 ]] && EDITOR="nano" || EDITOR="${4}"

function do_initialize {

echo -e "\nInstalling devtools and base-devel..."
sleep 1
echo "sudo pacman --needed -Sy devtools base-devel"
sudo pacman --color never --noprogressbar -q --needed -S devtools base-devel 3>&1 1>&2 2>&3 
sleep 1

echo -e "\nSetting up git..."
sleep 1
echo git config --global pull.rebase false
# git config --global pull.rebase false
sleep 1
echo git config --global push.default simple
# git config --global push.default simple
sleep 1
echo git config --global user.name "$NAME"
# git config --global user.name "$NAME"
sleep 1
echo git config --global user.email "$EMAIL"
# git config --global user.email "$EMAIL"
sleep 1
echo sudo git config --system core.editor $EDITOR
# sudo git config --system core.editor $EDITOR
sleep 1
echo git config --global credential.helper 'cache --timeout=32000'
# git config --global credential.helper 'cache --timeout=32000'
sleep 1

echo -e "\nMaking folders..."
sleep 1
echo "mkdir -p BUILD"
# mkdir -p BUILD
sleep 1
echo "mkdir -p SOURCE"
# mkdir -p SOURCE
sleep 1
echo "mkdir -p LOG"
# mkdir -p LOG
sleep 1
echo "mkdir -p PKGBUILDS"
# mkdir -p PKGBUILDS
sleep 1
echo "touch .firsttime"
# touch .firsttime
sleep 1

BUILDDIR="${SCRIPTPATH}/BUILD"
PKGDEST="${SCRIPTPATH}/x86_64"
SRCDEST="${SCRIPTPATH}/SOURCE"
SRCPKGDEST="${SCRIPTPATH}/src"
LOGDEST="${SCRIPTPATH}/LOG"

GPG_KEY=$(gpg --list-keys filip@kemuel.dk | head -n 2 | tail -n -1)
GPG_KEY=${GPG_KEY// /}

echo -e "\nSetting up makechroopkg environment..."
sleep 1
echo "echo \"export BUILDDIR=${BUILDDIR}\" > ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export BUILDDIR=${BUILDDIR}" > ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export PKGDEST=${PKGDEST}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export PKGDEST=${PKGDEST}" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export SRCDEST=${SRCDEST}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export SRCDEST=${SRCDEST}" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export SRCPKGDEST=${SRCPKGDEST}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export SRCPKGDEST=${SRCPKGDEST}" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export LOGDEST=${LOGDEST}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export LOGDEST=${LOGDEST}" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export PKGDEST=${PKGDEST}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export PKGDEST=${PKGDEST}" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export PACKAGER=${PACKAGER}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export PACKAGER=\"${PACKAGER}\"" >> ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
echo "echo \"export GPG_KEY=${GPG_KEY}\" >> ${SCRIPTPATH}/scripts/makeENV.sh"
echo "export GPG_KEY=${GPG_KEY}" >> ${SCRIPTPATH}/scripts/makeENV.sh
chmod +x ${SCRIPTPATH}/scripts/makeENV.sh
sleep 1
}

which dialog 1> /dev/null 2>&1 && {
	mi=1
	while read -r line; do
		case "$mi" in
		1)
			[[ -z "$line" ]] && {
				./initialize.sh "\Z1Error: you have to type a name!\Z0"
				exit 0
			} || {
				NAME="${line}"
			}
		;;
		2)
			[[ -z "$line" ]] && {
				./initialize.sh "\Z1Error: you have to type an email!\Z0" "${NAME}"
				exit 0
			} || {
				check_email "${line}" && {
					EMAIL="${line}"
				} || {
					./initialize.sh "\Z1Error: Doesn't seem to be a valid email!\Z0" "${NAME}"
					exit 0
				}
			}
		;;
		3)
			[[ -z "$line" ]] && {
				./initialize.sh "\Z1Error: you have to chooose an editor!\Z0" "${NAME}" "${EMAIL}"
				exit 0
			} || {
				which ${line} 1> /dev/null && {
					EDITOR="${line}"
				} || {
					./initialize.sh "\Z1Error: I can't find that editor!\Z0" "${NAME}" "${EMAIL}" "${line}"
					exit 0
				}
			}
		;;
		*)
		echo "Error: too many fields!"
		exit 1
		;;
		esac
		((mi++))
	done < <(DIALOGRC="${SCRIPTPATH}/.dialogrc" dialog --no-cancel --colors --backtitle "The kaistall-pac Repo Setup" --title  " Your GIT-identity " --form "
	${MESSAGE}" 0 0 5 "  Name:" 1 2 "${2}" 1 10 25 0 " Email:" 2 2 "${3}" 2 10 25 0 "Editor:" 4 2 "${EDITOR}" 4 10 25 0 3>&1 1>&2 2>&3)
} || {
	which whiptail 1> /dev/null 2>&1  && {
		NCOLORS="${NTHEME_OK}"
		MSG="
Name:"
		while true; do 
			NAME=$(NEWT_COLORS=${NCOLORS} whiptail --nocancel --backtitle "The kaistall-pac Repo Setup" --title " Your GIT-identity " --inputbox "${MSG}" 10 50 3>&1 1>&2 2>&3)
			[[ ! -z "${NAME}" ]] && break || {
				NCOLORS="${NTHEME_ERROR}"
				MSG="
Error: you have to type a name! 
Name:"
			}
		done
		NCOLORS="${NTHEME_OK}"
		MSG="
Email:"
		while true; do 
			EMAIL=$(NEWT_COLORS=${NCOLORS} whiptail --nocancel --backtitle "The kaistall-pac Repo Setup" --title " Your GIT-identity " --inputbox "${MSG}" 10 50 3>&1 1>&2 2>&3)
			[[ ! -z "${EMAIL}" ]] && {
				check_email "${EMAIL}" && {
					break
				} || {
					NCOLORS="${NTHEME_ERROR}"
					MSG="
Error: Doesn't seem to be a valid email! 
Email:"
				} 
	  		} || {
			NCOLORS="${NTHEME_ERROR}"
			MSG="
Error: you have to type an email! 
Email:"
			}
		done
		NCOLORS="${NTHEME_OK}"
		MSG="
Editor:"
		while true; do 
			EDITOR=$(NEWT_COLORS=${NCOLORS} whiptail --nocancel --backtitle "The kaistall-pac Repo Setup" --title " Your GIT-identity " --inputbox "${MSG}" 10 50 "nano" 3>&1 1>&2 2>&3)
			[[ ! -z "${EDITOR}" ]] && { 
				which ${EDITOR} 1> /dev/null && {
					break
				} || {
					NCOLORS="${NTHEME_ERROR}"
					MSG="
Error: I can't find that editor!
Editor:"
				} 
			} || {
			NCOLORS="${NTHEME_ERROR}"
			MSG="Error: You have to type an editor!
Editor:"
			}
		done
	} || {
		oldBOX "The kaistall-pac Repo Setup" "Your GIT-identity"
		mess="
Name:"
		while true
		do
			read -p "${mess} " NAME
				case $NAME in
					""|$'\0A'|$'\e')
						mess="$(c +R,+b)Error: you have to type a name! $(c r)
Name:"
					;;
					*)
						break
					;;
					esac
			echo -ne "\033[F\033[2K\r"
		done
		mess="
Email:"
		while true
		do
			read -p "${mess} " EMAIL
				case $EMAIL in
					""|$'\0A'|$'\e')
						mess="$(c +R,+b)Error: you have to type an email!$(c r)
Email:"
					;;
					*)
						check_email "${EMAIL}" && {
							break
						} || {
							mess="$(c +R,+b)Error: Doesn't seem to be a valid email! $(c r)
Email:"
						} 
					;;
				esac
			echo -ne "\033[F\033[2K\r"
		done
		mess="
Editor:"
		while true
		do
			read -p "${mess} " EDITOR
			case $EDITOR in
				""|$'\0A'|$'\e')
					mess="$(c +R,+b)Error: you have to type an editor!$(c r)
Editor:"
					echo -ne "\033[F\033[2K\r"
				;;
				*)
					which ${EDITOR} 1> /dev/null 2>&1 && {
						break
					} || {
						mess="$(c +R,+b)Error: I can't find that editor!$(c r)
Editor:"
						echo -ne "\033[F\033[2K\r"
					}
				;;
			esac
		done
	} 
}




clear


ynBOX "Setting up credentials for this repo" "
        Name : Filip Kemuel
       Email : filip@kemuel.dk

      Editor : tilde" "" "OK" "CANCEL"

[[ "$ynBOX_result" == "NO" ]] &&  exit 0

PACKAGER="${NAME} <${EMAIL}>"

which dialog 1> /dev/null 2>&1 && {
	do_initialize | dialog --backtitle "The kaistall-pac Repo Setup" --title "Initializing" --programbox "Running commands..."  22 75
} || {
	clear
	do_initialize
	echo -e "\n"
	read -n 1 -p "Press any key to continue...!"
	echo ""
}

ynBOX "MAKEPKG" "
We have added som environment variables to scripts/makeENV.sh.
It has all the build paths, and your GPG key associated with ${EMAIL}

It will be loaded everytime we build a package.

Please check the file to see if all values are correct.
" "Do you want to open makeENV.sh and check it ?" "YES" "NO"
[[ "$ynBOX_result" == "YES" ]] && $EDITOR ${SCRIPTPATH}/scripts/makeENV.sh


msgBOX "DONE!" "
 
You should now be able to build and upload packages."

