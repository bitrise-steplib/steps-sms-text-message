#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Start go program
cd "${THIS_SCRIPTDIR}"

go run ./step.go
ex_code=$?

if [ ${ex_code} -eq 0 ] ; then
  exit 0
fi

exit 1