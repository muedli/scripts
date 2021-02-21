#!/bin/bash

: '
This script is meant to be run in a directory that contains Git repos. It 
finds Git repos recursively and prints numbered aliases for them.
'

print_aliases() {
	
	# The first argument to the function is the directory. 
	DIR=$1

	# Loop over each file in the directory.
	for FILE in $DIR/*
	do

		# If the file is a directory...
		if [ -d $FILE ]
		then

			# If the directory is a Git repo...
			if [ -d $FILE/.git ]
			then
				(( REPO_INDEX++ ))
				echo "alias ${REPO_INDEX}=\"cd ${FILE}\""
			fi

			# Print aliases for repos in subdirectories.
			print_aliases $FILE
		fi
	done
}

# Get the directory supplied to the script.
DIR=$1

# If no directory has been supplied, use working directory.
if [ -z $DIR ]
then
	DIR="`pwd`"
fi

# For indexing repos.
REPO_INDEX=$(( 0 ))

# Print aliases for all Git repos!
echo "Add the following to your .bash_aliases or .zshrc..."
print_aliases $DIR
