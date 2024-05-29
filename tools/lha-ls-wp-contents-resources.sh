#!/bin/bash

POSTS_DIR="$*"

grep -ohER "\({{ site.lhajp_resources_url }}/wp-content/[^)]+\)" $POSTS_DIR | sed -e 's%^.*{{ site.lhajp_resources_url }}/wp-content/\([^)]*\).*$%\1%p' | sort | uniq


