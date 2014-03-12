#!/bin/bash
set -e

source require_clean_work_tree.sh
require_clean_work_tree

# measures size of gh_docs directory in blocks
gh_docs_size=`du -d 0 gh_docs/capture_temp gh_docs/engage_temp | awk '{print $1}' | awk '{s+=$1} END {print s}'`

# 3k or bail
if [[ "$gh_docs_size" -lt "3000" ]]; then
  echo Not enough stuff in gh_docs directory, not republishing
fi

gh_docs_from_branch=`git describe`

git checkout gh-pages
git pull
git rm -r gh_docs/capture
git rm -r gh_docs/engage
mv gh_docs/capture_temp gh_docs/capture
mv gh_docs/engage_temp gh_docs/engage
git add gh_docs/capture
git add gh_docs/engage
git commit -am "republish docs from $gh_docs_from_branch"
git checkout -

