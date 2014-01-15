#!/bin/bash

POST_TITLE="$1"
if [ -z "$POST_TITLE" ]; then
	echo "Usage: post.sh <post_title>"
	exit 1
fi

FILE_NAME=$(echo "$POST_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z_0-9]/-/g' | sed 's/--\+/-/g' | sed 's/^-\+//' | sed 's/-\+$//')
if [ -z "$FILE_NAME" ]; then
	echo "Filename must contain at least one symbol [a-z0-9_]"
	exit 1
fi

POST_DATE=$(date '+%Y-%m-%d %H:%M:%S')
FILE_DATE=$(echo "$POST_DATE" | grep -o '^[^ ]\+')
FULL_FILE_NAME="_posts/${FILE_DATE}-${FILE_NAME}.md"

touch "$FULL_FILE_NAME"
echo "---" >>"$FULL_FILE_NAME"
echo "layout: default" >>"$FULL_FILE_NAME"
echo "date: $POST_DATE" >>"$FULL_FILE_NAME"
echo "title: $POST_TITLE" >>"$FULL_FILE_NAME"
echo "---" >>"$FULL_FILE_NAME"
echo >>"$FULL_FILE_NAME"

vim "$FULL_FILE_NAME"
