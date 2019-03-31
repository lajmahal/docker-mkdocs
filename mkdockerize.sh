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

  # Check that the mkdocs project exists
  if [[ ! -d $mkdocsProjectPath ]]; then
    echo "mkdocs project path ($mkdocsProjectPath) does not exist, has it been mounted correctly?"
    exit 1
  fi

  cd $mkdocsProjectPath
  mkdocs build &> /dev/null # all output has to be suppressed, the only output should be the tar.gz stream

  # these files have to be copied into the site dir to be included in the tar.gz stream
  cp mkdocs.yml site/
  cp -r docs site/

  cd site
  tar -cz *
}

function serve_mkdocs () {
  mkdir site
  cd site
  tar -zxf -
  mv docs mkdocs.yml ../ # these files have to be moved up for mkdocs serve to work
  cd ../
  mkdocs serve -a 0.0.0.0:8000 # listen on all interfaces
}

# Main script
check_num_of_args $#
if [[ $1 == "produce" ]]; then
  produce_mkdocs_tgz "/data/mkdocs-project" # the project must be mounted as a volume in the container at this path
elif [[ $1 == "serve" ]]; then
  serve_mkdocs
else
  invalid_command
fi
