#!/usr/bin/env bash

function check_num_of_args () {
  local num_args=$1
  if [[ num_args -ne 1 ]]; then
    echo "Must supply exactly 1 argument"
    exit 1
  fi
}

function invalid_command () {
  echo "Invalid argument - must specify \"produce\" or \"serve\""
  exit 1
}

function produce_mkdocs_tgz () {
  local mkdocsProjectPath=$1

  if [[ ! -d $mkdocsProjectPath ]]; then
    echo "mkdocs project path ($mkdocsProjectPath) does not exist, has it been mounted correctly?"
    exit 1
  fi

  cd $mkdocsProjectPath
  mkdocs build > /dev/null
  cp mkdocs.yml site/
  cp -r docs site/
  cd site
  tar -cz *
}

function serve_mkdocs () {
  mkdir site
  cd site
  tar -zxf -
  mv docs mkdocs.yml ../
  cd ../
  mkdocs serve -a 0.0.0.0:8000
}

# Main script
check_num_of_args $#
if [[ $1 == "produce" ]]; then
  produce_mkdocs_tgz "/data/mkdocs-project"
elif [[ $1 == "serve" ]]; then
  serve_mkdocs
else
  invalid_command
fi
