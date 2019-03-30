#!/usr/bin/env bash

if [[ $# -ne 1 ]]
then
  echo "Must supply exactly 1 argument"
  exit 1
fi

if [[ $1 == "produce" ]]
then
  echo "Produce mkdocs tar.gz"
  exit 0
elif [[ $1 == "serve" ]]
then
  echo "Serve mkdocs"
  exit 0
else
  echo "Invalid argument - must specify \"produce\" or \"serve\""
  exit 1
fi
