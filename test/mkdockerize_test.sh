#!/usr/bin/env bash

# This is a basic test script to test the mkdockerize.sh main script
# included as an example script that can be invoked from the test stage
# of the Jenkins pipeline.
#
# This script doesn't cover the test cases that actually invoke the
# "produce" and "serve" commands because that would require mkdocs to be installed,
# which probably won't be the case on the Jenkins node running the pipeline.

function test_mkdockerize () {
  bash ./mkdockerize.sh $@ &> /dev/null
  retCode=$?
  if [[ $retCode -eq 1 ]]; then echo "...OK"
  else
    echo "expected retCode to be 1 but was $retCode"
    exit 1;
  fi
}

echo "1) Run without arguments should fail"
test_mkdockerize

echo "2) Run with too many arguments should fail"
test_mkdockerize arg1 arg2

echo "3) Run with anything other than \"produce\" or \"serve\" should fail"
test_mkdockerize somethingElse