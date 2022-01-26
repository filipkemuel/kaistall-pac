#!/usr/bin/env bash


NTHEME_OK="root=,black
border=white,black
window=white,black
shadow=,black
title=cyan,black
button=black,blue
entry=white,gray
textbox=white,black
roottext=cyan,black
compactbutton=white,black"

NTHEME_ERROR="root=,black
border=red,black
window=red,black
shadow=,black
title=cyan,black
button=black,red
entry=white,gray
textbox=red,black
roottext=cyan,black
compactbutton=red,black"

ynBOX_result="NO"

function c {

# USAGE: $(c [+COLOR],[++COLOR],[+EFFECT]...)TEXT$(c [--COLOR],[-COLOR],[-EFFECT])
#
#        COLORS are uppercase ex: R = Red, B = Blue
#        EFFECTS are lowercase ex: b = bold, i = italic
#        Colors and effects are set with + and reset with -
#        Bachground colors are set with ++ and reset with --
#        0 means Black since both black and blue starts with B

for i in ${1//,/ }; do
	case $i in
		+r|+reset|-r|-reset|r|reset)
			echo -ne "\033[0m"
		;;
		+b|+bold)
			echo -ne "\033[1m"
		;;
		+f|+faint|+d|+dim)
			echo -ne "\033[1m"
		;;
		-b|-bold|-f|-faint|-d|-dim)
			echo -ne "\033[22m"
		;;
		+i|+italic)
			echo -ne "\033[3m"
		;;
		-i|-italic)
			echo -ne "\033[23m"
		;;
		+u|+underline)
			echo -ne "\033[4m"
		;;
		+2u|+2underline|x2u|+x2u)
			echo -ne "\033[21m"
		;;
		-u|-underline|-2u|-2underline|-x2u)
			echo -ne "\033[24m"
		;;
		+a|+alert)
			echo -ne "\033[5m"
		;;
		-a|-alert)
			echo -ne "\033[25m"
		;;
		+n|+negative)
			echo -ne "\033[7m"
		;;
		-n|-negative)
			echo -ne "\033[27m"
		;;
		+h|+hidden)
			echo -ne "\033[8m"
		;;
		-h|-hidden)
			echo -ne "\033[28m"
		;;
		+s|+strike|+strikethrough)
			echo -ne "\033[9m"
		;;
		-s|-strike|-strikethrough)
			echo -ne "\033[29m"
		;;
		+0|+[Bb][Ll][Aa][Cc][Kk])
			echo -ne "\033[30m"
		;;
		+R|+[Rr][Ee][Dd])
			echo -ne "\033[31m"
		;;
		+G|+[Gg][Rr][Ee][Ee][Nn])
			echo -ne "\033[32m"
		;;
		+Y|+[Yy][Ee][Ll][Ll][Oo][Ww])
			echo -ne "\033[33m"
		;;
		+B|+[Bb][Ll][Uu][Ee])
			echo -ne "\033[34m"
		;;
		+M|+[Mm][Aa][Gg][Ee][Nn][Tt][Aa])
			echo -ne "\033[35m"
		;;
		+C|+[Cc][Yy][Aa][Nn])
			echo -ne "\033[36m"
		;;
		+W|+[Ww][Hh][Ii][Tt][Ee])
			echo -ne "\033[37m"
		;;
		-0|-[Bb][Ll][Aa][Cc][Kk])
			echo -ne "\033[39m"
		;;
		-R|-[Rr][Ee][Dd])
			echo -ne "\033[39m"
		;;
		-G|-[Gg][Rr][Ee][Ee][Nn])
			echo -ne "\033[39m"
		;;
		-Y|-[Yy][Ee][Ll][Ll][Oo][Ww])
			echo -ne "\033[39m"
		;;
		-B|-[Bb][Ll][Uu][Ee])
			echo -ne "\033[39m"
		;;
		-M|-[Mm][Aa][Gg][Ee][Nn][Tt][Aa])
			echo -ne "\033[39m"
		;;
		-C|-[Cc][Yy][Aa][Nn])
			echo -ne "\033[39m"
		;;
		-W|-[Ww][Hh][Ii][Tt][Ee])
			echo -ne "\033[39m"
		;;
		+D|+[Dd][Ee][Ff][Aa][Uu][Ll][Tt]|-D|-[Dd][Ee][Ff][Aa][Uu][Ll][Tt]|D|[Dd][Ee][Ff][Aa][Uu][Ll][Tt])
			echo -ne "\033[39m"
		;;
		
		
		++0|++[Bb][Ll][Aa][Cc][Kk])
			echo -ne "\033[40m"
		;;
		++R|++[Rr][Ee][Dd])
			echo -ne "\033[41m"
		;;
		++G|++[Gg][Rr][Ee][Ee][Nn])
			echo -ne "\033[42m"
		;;
		++Y|++[Yy][Ee][Ll][Ll][Oo][Ww])
			echo -ne "\033[43m"
		;;
		++B|++[Bb][Ll][Uu][Ee])
			echo -ne "\033[44m"
		;;
		++M|++[Mm][Aa][Gg][Ee][Nn][Tt][Aa])
			echo -ne "\033[45m"
		;;
		++C|++[Cc][Yy][Aa][Nn])
			echo -ne "\033[46m"
		;;
		++W|++[Ww][Hh][Ii][Tt][Ee])
			echo -ne "\033[47m"
		;;
		--0|--[Bb][Ll][Aa][Cc][Kk])
			echo -ne "\033[49m"
		;;
		--R|--[Rr][Ee][Dd])
			echo -ne "\033[49m"
		;;
		--G|--[Gg][Rr][Ee][Ee][Nn])
			echo -ne "\033[49m"
		;;
		--Y|--[Yy][Ee][Ll][Ll][Oo][Ww])
			echo -ne "\033[49m"
		;;
		--B|--[Bb][Ll][Uu][Ee])
			echo -ne "\033[49m"
		;;
		--M|--[Mm][Aa][Gg][Ee][Nn][Tt][Aa])
			echo -ne "\033[49m"
		;;
		--C|--[Cc][Yy][Aa][Nn])
			echo -ne "\033[49m"
		;;
		--W|--[Ww][Hh][Ii][Tt][Ee])
			echo -ne "\033[49m"
		;;
		++D|++[Dd][Ee][Ff][Aa][Uu][Ll][Tt]|--D|--[Dd][Ee][Ff][Aa][Uu][Ll][Tt]|D|[Dd][Ee][Ff][Aa][Uu][Ll][Tt])
			echo -ne "\033[49m"
		;;
	esac

done

}

function check_email {

# USAGE: check_email EMAIL && TRUE_ACCTION || FALSE_ACTION

	[[ "${1}" =~ ^([a-z0-9.\!#$%&\'*+=?^_\`\{|\}~-]+)@(.+) ]] && {
	   user=${BASH_REMATCH[1]}
	   host=${BASH_REMATCH[2]}
	   ping -c 1 ${host} &> /dev/null && {
		   return 0
	   } || {
		   return 1
	   }
	} || {
		return 1
	}
}


function oldBOX {

# USAGE: oldBOX TITLE MESSAGE [WIDTH]

[[ -z $3 ]] && width=50 || width=$3

border=""
empty=""
for (( i = 0; i < $(expr ${width} - 2 ); i++ )); do
	border="${border}─"
	empty="${empty} "
done

iw=$(expr ${width} - 6 )

echo "┌${border}┐"
while read -r line
do
	filler=""
	length=${#line}
	[[ $((length%2)) -eq 0 ]] && {
		[[ $((width%2)) -eq 0 ]] && ex="" || ex=" " 
	} || {
		[[ $((width%2)) -eq 0 ]] && ex=" " || ex="" 
	}
	spaces=$(expr $(expr ${iw} - ${length} ) / 2 )
	for (( i = 0; i < spaces; i++ )); do
		      filler="${filler} "
	done
	printf "%s%s%s%s%s" "│  " "${filler}" "$line" "${filler}${ex}" "  │" 
	printf "\n"
done < <(echo "${1}" | fold -w ${iw} -s )
echo "├${border}┤"
#echo "│${empty}│" 
while read -r line
do
	filler=""
	spaces=$(expr ${iw} - ${#line} )
	for (( i = 0; i < spaces; i++ )); do
		      filler="${filler} "
	done
	printf "%s%s%s%s" "│  " "$line" "${filler}" "  │" 
	printf "\n"
done < <(echo "${2}" | fold -w ${iw} -s )
echo "│${empty}│" 
echo "└${border}┘"

}

function msgBOX {

# USAGE: msgBOX TITLE MESSAGE

NCOLORS="${NTHEME_OK}"
which dialog 1> /dev/null 2>&1 && {
		DIALOGRC="${SCRIPTPATH}/.dialogrc" dialog --no-collapse --backtitle "The kaistall-pac Repo Setup" --title " $1 " --msgbox "$2" 10 50
	} || {
		which whiptail 1> /dev/null 2>&1 && {
			NEWT_COLORS=${NCOLORS} whiptail --backtitle "The kaistall-pac Repo Setup" --title " $1 " --msgbox "$2" 12 50
		} || {
			
			oldBOX "$1" "$2" 50
			echo ""
		    read -n 1 -p "Press any key to continue...!"

		}
	}
}

function ynBOX {

# USAGE: ynBOX TITLE MESSAGE [QUESTION] [YES_TEXT] [NO_TEXT]
#        [[ ynBOX_result == "YES" ]] && YES_ACTION || NO_ACTION

[[ -z $4 ]] && yB="Yes" || yB="${4}"
[[ -z $5 ]] && nB="No" || nB="${5}"

NCOLORS="${NTHEME_OK}"
which dialog 1> /dev/null 2>&1 && {
		DIALOGRC="${SCRIPTPATH}/.dialogrc" dialog --no-collapse --backtitle "The kaistall-pac Repo Setup" --title " $1 " --yes-label "${yB}" --no-label "${nB}" --yesno "
$2
$3
 
" 0 0 
	if [ $? = 0 ]; then
		ynBOX_result="YES"
	elif  [ $? = 1 ]; then
		ynBOX_result="NO"
	else
		exit 1
	fi
	} || {
		which whiptail 1> /dev/null 2>&1 && {
			NEWT_COLORS=${NCOLORS} whiptail --backtitle "The kaistall-pac Repo Setup" --title " $1 " --yes-button "${yB}" --no-button "${nB}" --yesno "$2
$3
 
" 0 0
	if [ $? = 0 ]; then
		ynBOX_result="YES"
	elif  [ $? = 1 ]; then
		ynBOX_result="NO"
	else
		exit 1
	fi
		} || {
			yK="${yB::1}"
		    nK=${nB::1}
		    [[ -z $3 ]] && {
		    	Que="[ $(c +G +u)${yK^}$(c r)${yB/${yK}/} ]  or  [ $(c +G +u)${nK^}$(c r)${nB/${nK}/} ]   ($(c +G)${yK^}$(c r)/$(c +R)${nK^}$(c r)): " 
		    } || {
		    	Que="$3 ($(c +G)${yK^}$(c r)/$(c +R)${nK^}$(c r))"
		    }
			oldBOX "$1" "$2" 50
			echo ""
			while true
			do
				read -s -n 1 -p "${Que}" edit
					case $edit in
					${nK^}|${nK,}|[nN]|$'\e')
						ynBOX_result="NO"
						echo -ne "\033[2K\r"
						break
					;;
					${yK,}|${yK^}|[yN]|$'\0A')
						ynBOX_result="YES"
						echo -ne "\033[2K\r"
						break
					;;
					*)
					echo -ne "\033[2K\r"
				esac
			done
		}
	}
}
