#!/bin/bash
#Assume that argument 1 is the name of the zippepd file

fileName1=${1:-MYSTERIOUS_FILE}
fileName2=""
count=$2

# Checks for first run (no count given)
# Copies input file for backup purposes
case $count in
	'') 
		count=0
		cp $fileName1 file_backup
		echo ""
		echo "Patience, my blue friend. You'll have your winnings before the suns set, and we'll be far away from here."
		;;
	*) let "count++";;
esac

# Case statement modifies the output file names
# On the first run (as long as filename isn't file1 or file2)
# a backup will be made because safety.
# Otherwise alternate output filenames between file1 and file2
# We do this to overwrite and not fill up the directory
case $fileName1 in
	"file2")
		fileName2="file1";;
	"file1")
		fileName2="file2";;
	*)
		export bzipcnt=0
		export posixcnt=0
		export gzipcnt=0
		fileName2="file1";;
esac

# Grab the file type using the find command. Awk selects the first field (the only field returned)
fileType=$(file -b $fileName1 | awk ' { print $1 } ')


# Match the file type and decompress accordingly
# Recursevely call file_expander.sh
# If no match output file type and cat the file
case $fileType in
	"bzip2") 
		export bzipcnt=$(($bzipcnt+1));
		bzip2 -dc $fileName1 > $fileName2;;
	"POSIX") 
		export posixcnt=$(($posixcnt+1))
		tar -xOf $fileName1 > $fileName2;;
	"gzip") 
		export gzipcnt=$(($gzipcnt+1))
		gzip -dc $fileName1 > $fileName2;;
	*)
		finished=true;;
esac

# Progress dots
echo -n .

# Print contents of file if finished/could not decompress
# or recurse
case $finished in
	true)
		echo ""
		echo "Last file type: $fileType"
		echo -n "Posix files encountered: "
		echo $posixcnt
		echo -n "Bzip files ecnountered: "
		echo $bzipcnt
		echo -n "Gzip files encountered: "
		echo $gzipcnt
		echo -n "Total files encountered: "
		echo $count
		echo -n "Content of last file:"
                cat $1
		;;
	*)./file_expander.sh $fileName2 $count;;
esac
