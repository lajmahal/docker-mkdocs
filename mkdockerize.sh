#!/usr/bin/env bash

mkdocsProjectPath="/data/mkdocs-project"
if [[ $# -ne 1 ]]; then
  echo "Must supply exactly 1 argument"
  exit 1
elif [[ $1 == "produce" ]]; then
  if [[ ! -d $mkdocsProjectPath ]]; then
    echo "mkdocs project path ($mkdocsProjectPath) does not exist, has it been mounted correctly?"
    exit 1
  fi
  cd $mkdocsProjectPath
  mkdocs build > /dev/null
  cd site
  tar -cz *
  exit 0
elif [[ $1 == "serve" ]]; then
  echo "Serve mkdocs"
  exit 0
else
  echo "Invalid argument - must specify \"produce\" or \"serve\""
  exit 1
fi
