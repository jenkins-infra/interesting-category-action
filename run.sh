#!/bin/bash
set -euxo pipefail
if [ $GITHUB_EVENT_NAME = check_run ]
then
    if [ -z "$RELEASE_DRAFT_BODY" ]; then
        RESULT=$(gh api /repos/$GITHUB_REPOSITORY/releases | jq -e -r '.[] | select(.draft == true and .name == "next") | .body' | egrep "$INTERESTING_CATEGORIES" || echo 'failed')
    else
        RESULT=$(echo "$RELEASE_DRAFT_BODY" | egrep "$INTERESTING_CATEGORIES" || echo 'failed')
    fi
    if [[ $RESULT != 'failed' ]]; then
      echo "::set-output name=interesting::true"
    else
      echo "::set-output name=interesting::false"
    fi
else
  echo "::set-output name=interesting::true"
fi
