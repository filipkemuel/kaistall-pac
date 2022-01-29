#!/usr/bin/env bash


SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

cd "${SCRIPTPATH}/x86_64"

maxSize=10000000

for file in *.pkg.tar.zst
do
	mySize=$(stat -c%s ${file})
	(( mySize > maxSize )) && {
		echo "${file} is too big for the repo: $(eval ${mySize} / 100000 )Mb"
		echo "Max size is 100Mb!"
		echo "You need to remove it!"
		exit 1
	}
done

rm kaistall-pac*

repo-add -s -n -R kaistall-pac.db.tar.gz *.pkg.tar.zst


rm kaistall-pac.db
rm kaistall-pac.db.sig

rm kaistall-pac.files
rm kaistall-pac.files.sig

mv kaistall-pac.db.tar.gz kaistall-pac.db
mv kaistall-pac.db.tar.gz.sig kaistall-pac.db.sig

mv kaistall-pac.files.tar.gz kaistall-pac.files
mv kaistall-pac.files.tar.gz.sig kaistall-pac.files.sig

echo "Done! "

${SCRIPTPATH}/scripts/generate_markdown.sh
