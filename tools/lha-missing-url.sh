#!/bin/bash

POSTS_DIR="$*"

REF_URLS_FILE=/tmp/ref_urls.txt
PRESENTED_URLS_FILE=/tmp/presented_urls.txt
DRAFTS_URLS_FILE=/tmp/drafts_urls.txt
MISSING_URLS_FILE=/tmp/missing_urls.txt
MISSING_ATTACHMENTS_FILE=/tmp/missing_attachments.txt
ATTACHMENT_SUBST_FILE=/tmp/attachment_subst.txt

grep -ohER "\]\([^)]+\)" $POSTS_DIR | sed -e 's/^.*(\(.*\)).*$/\1/p' | grep '^/wp/' | sort | uniq >$REF_URLS_FILE

grep -R "^permalink: " $POSTS_DIR | grep -v "/_drafts/" > $PRESENTED_URLS_FILE
grep -R "^permalink: " $POSTS_DIR | grep "/_drafts/" > $DRAFTS_URLS_FILE

rm -f $MISSING_URLS_FILE
rm -f $MISSING_ATTACHMENTS_FILE
rm -f $ATTACHMENT_SUBST_FILE
while read url; do
  if ! grep -q "permalink: $url$" $PRESENTED_URLS_FILE; then
    # try to find the page from the attachments pages
    matched=$(grep "permalink: $url$" $DRAFTS_URLS_FILE | cut -d : -f 1)
    if [ -z "$matched" ]; then
      # try to find a new link for the attachment file
      if [[ $url =~ ^/wp/\?attachment_id=([0-9]+)$ ]]; then
	id=${BASH_REMATCH[1]}
	matched=$(grep -R "^wordpress_id: $id$" $POSTS_DIR | cut -d : -f 1)
        #permalink=$(grep "^permalink: " $matched | sed -e 's/^permalink:\s*//')
	#echo "  '/wp/\?attachment_id=$id': '$permalink'," >>$ATTACHMENT_SUBST_FILE
        attachment_url=$(grep "^attachment_url: " $matched | sed -e 's/^attachment_url:\s*//')
	echo "  '/wp/\?attachment_id=$id': '$attachment_url'," >>$ATTACHMENT_SUBST_FILE
      fi
    fi

    if [ -n "$matched" ]; then
	echo $matched  >>$MISSING_ATTACHMENTS_FILE
    else
        echo "$url"
        echo "$url" >>$MISSING_URLS_FILE
    fi
  fi
done < $REF_URLS_FILE

