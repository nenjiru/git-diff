#!/bin/sh

if [ "$#" -lt 2 ]
then
	echo "usage: git-diff [target] [export]"
	echo "example: git-diff master ../files"
	exit 1
fi

## Export directory
putdir=$2
putdir=`dirname ${putdir}`"/"`basename ${putdir}`

if [ ! -d $putdir ]
then
	mkdir -p $putdir
fi


## Git diff
git diff --name-status $1 > "$putdir.txt"


## File export
while read diff
do
	if [[ $diff =~ ^[AM] ]]
	then
		file=`echo $diff | cut -d " " -f 2`
		dir="$putdir/"`dirname ${file} | sed 's/\.//'`
		
		if [ ! -d $dir ]
		then
			mkdir -p $dir
		fi
		
		cp $file $dir
		echo "- $file"
	fi
done < "$putdir.txt"

echo "done."
exit 0
