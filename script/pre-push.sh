#!/bin/sh
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
echo $MESSAGE

if [[ "$MESSAGE" == *\[email\]* ]]; then
        echo "commit messag check ok"
else
        echo "your commit message needs to include [email]"
fi