#!/bin/bash
set -euxo pipefail
if [ $GITHUB_EVENT_NAME = check_run ]
then
    if [ -z "$RELEASE_DRAFT_BODY" ]; then
        RELEASE_DRAFT_BODY="$(gh api /repos/$GITHUB_REPOSITORY/releases | jq -e -r '.[] | select(.draft == true and .name == "next") | .body')"
    fi

    RESULT=$(echo "$RELEASE_DRAFT_BODY" | egrep "$INTERESTING_CATEGORIES" || echo 'failed')
    if [[ $RESULT != 'failed' ]]; then
      echo "::set-output name=interesting::true"
    else
      echo "::set-output name=interesting::false"
    fi
else
  echo "::set-output name=interesting::true"
fi
