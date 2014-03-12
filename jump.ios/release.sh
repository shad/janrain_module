#!/bin/bash

set -e

source require_clean_work_tree.sh
require_clean_work_tree

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <release_version_string>"
  echo
  echo "Where <release_version_string> is like v3.4.5"
  exit 1
fi

# TODO check that the pre-commit hook is set up.

git tag -a "$1" -m "$1"

# Runs the pre-commit hook to put the release version in JREngage-Info.plist.
git commit --allow-empty -m "$1"
