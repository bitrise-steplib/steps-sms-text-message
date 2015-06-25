#!/bin/bash

set -e

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${THIS_SCRIPT_DIR}/.."

#
# Script for Continuous Integration
#

set -v

go build
go test markdownlog_test.go markdownlog.go
#
# ==> DONE - OK
#