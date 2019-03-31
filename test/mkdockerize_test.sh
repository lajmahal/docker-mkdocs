#!/usr/bin/env bash

function test () {
  bash ./mkdockerize.sh $@ &> /dev/null
  retCode=$?
  if [[ $retCode -eq 1 ]]; then echo "...OK"
  else
    echo "expected retCode to be 1 but was $retCode"
    exit 1;
  fi
}

echo "1) Run without arguments should fail"
test

echo "2) Run with too many arguments should fail"
test arg1 arg2

echo "3) Run with anything other than \"produce\" or \"serve\" should fail"
test somethingElse