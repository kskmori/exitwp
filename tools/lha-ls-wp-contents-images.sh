#!/bin/bash

POSTS_DIR="$*"

grep -ohER "\(/assets/images/wp-content/[^)]+\)" $POSTS_DIR | sed -e 's%^.*/assets/images/wp-content/\([^)]*\).*$%\1%p' | sort | uniq


