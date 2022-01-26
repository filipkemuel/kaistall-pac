#!/usr/bin/env bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/utils.sh
source ${SCRIPTPATH}/makeENV.sh

Qpackage="${1}"
Qpath="$( cd -- "${SCRIPTPATH}/.." >/dev/null 2>&1 ; pwd -P )/"
Qext="pkg.tar.zst"
PACrolling=0
BUILD=0

function get_ver {
while read -r line
	do
	case "${line}" in
		pkgver\(\)*)
			PACrolling=1
		;;
		pkgname*)
			eval ${line}
		;;
		pkgver*)
			[[ -z "${PACver}" ]] && PACver=${line/pkgver=/}
		;;
		pkgrel*)
			PACrel=${line/pkgrel=/}
		;;
		epoch*)
			PACepoch=${line/epoch=}
		;;
		arch*)
		    [[ "$line" =~ x86_64 ]] && PACarch="x86_64" || {
			[[ "$line" =~ any ]] && PACarch="any" || {
				echo -e "$(c +R)Oh, this package can't be build here$(c .R)"
				theArch=${line/arch=\(}
				theArch=${theArch/\)/}
				echo -e "$(c +R)It's ment for ${theArch} $(c -R)"
				exit 1 
			} }
		;;
	esac
	
	done< <(cat ${Qpath}PKGBUILDS/${Qpackage}/PKGBUILD | awk '/^epoch|^pkgver|^pkgrel|^pkgname|^arch/')


	[[ -z "${PACepoch}" ]] || PACepoch="${PACepoch}:"
}

echo ""

[[ -f "${Qpath}PKGBUILDS/${Qpackage}/PKGBUILD" ]] && {
	
	get_ver
	
    i=1
	for PACage in ${pkgname[@]}
	do
		echo "PACKAGE (${i}): ${PACage}-${PACepoch}${PACver}-${PACrel}-${PACarch}.${Qext}"
		[[ -f "${Qpath}x86_64/${PACage}-${PACepoch}${PACver}-${PACrel}-${PACarch}.${Qext}" ]] && {
			[[ $PACrolling = 1 ]] && {
				echo -e "$(c +G)Already built!$(c -G)"
				echo -e "$(c +Y)But since version is updated on build we probably should build again!$(c -Y)"
				BUILD=1
			} || {
				echo -e "$(c +G)Already built!$(c -G)"
			}
		} || { 
			echo -e "$(c +G)Not built, let's do this$(c -G)"
			BUILD=1
		}
	((i++))
	done
	
} || {
	echo -e "$(c +R)No PKGBUILD found for ${Qpackage}, did you forget to run get_pkgbuilds.sh?$(c -R)"
	echo ""
	exit 1
}
echo ""
[[ $BUILD = 1 ]] && {
	echo -e "$(c +B)Starting build..$(c -B)" 
	cd ${Qpath}PKGBUILDS/${Qpackage}
	[[ -f "${Qpath}/.firsttime" ]] && {
		extra-x86_64-build -U kemuel
		success=$?
		rm ${SCRIPTPATH}/.firsttime
	} || {
		makechrootpkg -n -r /var/lib/archbuild/extra-x86_64
		success=$?
	}
	[[ $success = 0 ]] && {
		[[ $PACrolling = 1 ]] && get_ver
		echo ""
		for PACage in ${pkgname[@]}
		do
			echo -e"$(c +B)Signing ${PACage}...$(c -B)"
			gpg --default-key ${GPG_KEY} --yes --batch \
			--detach-sign "${Qpath}x86_64/${PACage}-${PACepoch}${PACver}-${PACrel}-${PACarch}.${Qext}"
		done
	} || {
		echo -e "$(c +R)Build finished with errors!$(c -R)"
		exit 1
	}
} || {
	echo -e "$(c +Y)Build was not needed... NEXT!$(c -Y)"
}
echo ""
