#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


echo "┌──────────────────────────────────────┐"
echo "│ Setting up credentials for this repo │"
echo "├──────────────────────────────────────┤"
echo "│                                      │"
echo "│        Name : Filip Kemuel           │"
echo "│       Email : filip@kemuel.dk        │"
echo "│                                      │"
echo "│      Editor : nano                   │"
echo "│                                      │"
echo "└──────────────────────────────────────┘"

git config --global pull.rebase false
git config --global push.default simple
git config --global user.name "Filip Kemuel"
git config --global user.email "filip@kemuel.dk"
sudo git config --system core.editor nano
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=32000'

mkdir -p BUILD
mkdir -p SOURCE
mkdir -p LOG
mkdir -p PKGBUILDS
touch .firsttime
sudo pacman --needed -S devtools

echo "┌──────────────────────────────────────┐"
echo "│                DONE!                 │"
echo "├──────────────────────────────────────┤"
echo "│                                      │"
echo "│ Remember to add the following info   │"
echo "│ to your makepkg.conf                 │"
echo "│                                      │"
echo "└──────────────────────────────────────┘"
echo ""
echo "PKGDEST=${SCRIPTPATH}/x86_64"
echo "SRCDEST=${SCRIPTPATH}/SOURCE"
echo "BUILDDIR=${SCRIPTPATH}/BUILD"
echo "LOGDEST=${SCRIPTPATH}/LOG"
echo "PACKAGER=\"Filip Kemuel <filip@kemuel.dk>\""
echo "GPGKEY=\"YOURGPGKEYHERE\""

