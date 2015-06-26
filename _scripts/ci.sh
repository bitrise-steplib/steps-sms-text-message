#!/bin/bash

set -e

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
# Script for Continuous Integration
#

${THIS_SCRIPT_DIR}/../step_test.sh

#
# ==> DONE - OK
#