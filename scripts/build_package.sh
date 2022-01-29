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
# Check if it's a rolling package !
while read -r line
do
	case "${line}" in
		pkgver\(\)*)
		echo "$(c +Y)Oh, It's a rolling package!$(c -Y)"
			echo "$(c +B)We need to fetch sources, run prepare() and then pkgver() to get the proper version!$(c -B)"
			echo ""
			cd ${Qpath}PKGBUILDS/${Qpackage}
			makechrootpkg -r /var/lib/archbuild/extra-x86_64 -- --nobuild 
			[[ $? = 0 ]] || {
				echo "$(c +R)Refreshing sources exited with an error!$(c -R)"
				exit 1
			}
		;;
	esac
done< <(cat ${Qpath}PKGBUILDS/${Qpackage}/PKGBUILD | awk '/^pkgver/')


# This way only worked if there was no variables in the name or version
# while read -r line
# do
# 	case "${line}" in
# 		pkgname*)
# 			pkgname=${line/pkgname=/}
# 		;;
# 		pkgver\=*)
# 			pkgver=${line/pkgver=/}
# 		;;
# 		pkgrel*)
# 			pkgrel=${line/pkgrel=/}
# 		;;
# 		epoch*)
# 			pkgepoch=${line/epoch=}
# 		;;
# 		arch*)
# 		    [[ "$line" =~ x86_64 ]] && arch="x86_64" || {
# 			[[ "$line" =~ any ]] && arch="any" || {
# 				echo -e "$(c +R)Oh, this package can't be build here$(c .R)"
# 				theArch=${line/arch=\(}
# 				theArch=${theArch/\)/}
# 				echo -e "$(c +R)It's ment for ${theArch} $(c -R)"
# 				exit 1 
# 			} }
# 		;;
# 	esac
# done< <(cat ${Qpath}PKGBUILDS/${Qpackage}/PKGBUILD | awk '/^epoch|^pkgver|^pkgrel|^pkgname|^arch/')

# New version - this seems potetially dangerous though since we are sourcing an "unknown script"
# TODO: Might be a good idea to setup some sort of jail around this

cd ${Qpath}PKGBUILDS/${Qpackage}
source PKGBUILD


[[ -z "${epoch}" ]] || epoch="${epoch}:"

for testArch in "${arch[@]}"; do
	case $testArch in
		any)
			[[ -z "${theArch}" ]] && theArch="any"
		;;
		x86_64)
			theArch="x86_64"
		;;
		*)
			[[ -z "${otherArch}" ]] && otherArch="${testArch}" || otherArch="and ${testArch}"
		;;
	esac
done

[[ -z "${theArch}" ]] && {
	echo -e "$(c +R)Oh, this package can't be build here$(c .R)"
	echo -e "$(c +R)It's ment for ${otherArch} $(c -R)"
	exit 1 
}

}

echo ""
echo "$(c +B)Looking op version information on ${Qpackage}..$(c -B)"
echo ""

[[ -f "${Qpath}PKGBUILDS/${Qpackage}/PKGBUILD" ]] && {
	
	get_ver
	
    i=1
	for PACage in ${pkgname[@]}
	do
		echo "PACKAGE (${i}): ${PACage}-${epoch}${pkgver}-${pkgrel}-${theArch}.${Qext}"
		[[ -f "${Qpath}x86_64/${PACage}-${epoch}${pkgver}-${pkgrel}-${theArch}.${Qext}" ]] && {
			echo -e "$(c +G)Already built!$(c -G)"
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
		echo ""
		for PACage in ${pkgname[@]}
		do
			echo -e"$(c +B)Signing ${PACage}...$(c -B)"
			gpg --default-key ${GPG_KEY} --yes --batch \
			--detach-sign "${Qpath}x86_64/${PACage}-${epoch}${pkgver}-${pkgrel}-${theArch}.${Qext}"
		done
	} || {
		echo -e "$(c +R)Build finished with errors!$(c -R)"
		exit 1
	}
} || {
	echo -e "$(c +Y)Build was not needed... NEXT!$(c -Y)"
}
echo ""
