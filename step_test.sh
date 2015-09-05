#!/bin/bash

#
# Run it from the directory which contains step.sh
#


# ------------------------
# --- Helper functions ---

function print_and_do_command {
  echo "$ $@"
  $@
}

function inspect_test_result {
  if [ $1 -eq 0 ]; then
    test_results_success_count=$[test_results_success_count + 1]
  else
    test_results_error_count=$[test_results_error_count + 1]
  fi
}

#
# First param is the expect message, other are the command which will be executed.
#
function expect_success {
  expect_msg=$1
  shift

  echo " -> $expect_msg"
  $@
  cmd_res=$?

  if [ $cmd_res -eq 0 ]; then
    echo " [OK] Expected zero return code, got: 0"
  else
    echo " [ERROR] Expected zero return code, got: $cmd_res"
    exit 1
  fi
}

#
# First param is the expect message, other are the command which will be executed.
#
function expect_error {
  expect_msg=$1
  shift

  echo " -> $expect_msg"
  $@
  cmd_res=$?

  if [ ! $cmd_res -eq 0 ]; then
    echo " [OK] Expected non-zero return code, got: $cmd_res"
  else
    echo " [ERROR] Expected non-zero return code, got: 0"
    exit 1
  fi
}

function is_dir_exist {
  if [ -d "$1" ]; then
    return 0
  else
    return 1
  fi
}

function is_file_exist {
  if [ -f "$1" ]; then
    return 0
  else
    return 1
  fi
}

function is_not_empty {
  if [[ $1 ]]; then
    return 0
  else
    return 1
  fi
}

function test_env_cleanup {
  unset account_sid
	unset auth_token
	unset to_number
	unset from_number
	unset message
	unset sms_media
}

function print_new_test {
  echo
  echo "[TEST]"
}


# -----------------
# --- Run tests ---

echo "Starting tests..."

test_ipa_path="tests/testfile.ipa"
test_results_success_count=0
test_results_error_count=0


# [TEST] Call the command with account_sid not set,
# it should raise an error message and exit
#
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export auth_token="dsa4321"
  export to_number="dsa4321"
  export from_number="dsa4321"
  export message="dsa4321"
  export sms_media="dsa4321"

  # All env vars should exist except account_sid
  expect_error "account_sid environment variable should NOT be set" is_not_empty "$account_sid"
  expect_success "auth_token environment variable should be set" is_not_empty "$auth_token"
  expect_success "to_number environment variable should be set" is_not_empty "$to_number"
  expect_success "from_number environment variable should be set" is_not_empty "$from_number"
  expect_success "message environment variable should be set" is_not_empty "$message"
	expect_success "sms_media environment variable should be set" is_not_empty "$sms_media"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with auth_token not set,
# it should raise an error message and exit
#
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export account_sid="dsa4321"
  export to_number="dsa4321"
  export from_number="dsa4321"
  export message="dsa4321"
  export sms_media="dsa4321"

  # All env vars should exist except auth_token
  expect_success "account_sid environment variable should be set" is_not_empty "$account_sid"
  expect_error "auth_token environment variable should NOT be set" is_not_empty "$auth_token"
  expect_success "to_number environment variable should be set" is_not_empty "$to_number"
  expect_success "from_number environment variable should be set" is_not_empty "$from_number"
  expect_success "message environment variable should be set" is_not_empty "$message"
	expect_success "sms_media environment variable should be set" is_not_empty "$sms_media"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with to_number not set,
# it should raise an error message and exit
#
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export account_sid="dsa4321"
  export auth_token="dsa4321"
  export from_number="dsa4321"
  export message="dsa4321"
  export sms_media="dsa4321"

  # All env vars should exist except to_number
  expect_success "account_sid environment variable should be set" is_not_empty "$account_sid"
  expect_success "auth_token environment variable should be set" is_not_empty "$auth_token"
  expect_error "to_number environment variable should NOT be set" is_not_empty "$to_number"
  expect_success "from_number environment variable should be set" is_not_empty "$from_number"
  expect_success "message environment variable should be set" is_not_empty "$message"
	expect_success "sms_media environment variable should be set" is_not_empty "$sms_media"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with from_number not set,
# it should raise an error message and exit
#
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export account_sid="dsa4321"
  export auth_token="dsa4321"
  export to_number="dsa4321"
  export message="dsa4321"
  export sms_media="dsa4321"

  # All env vars should exist except from_number
  expect_success "account_sid environment variable should be set" is_not_empty "$account_sid"
  expect_success "auth_token environment variable should be set" is_not_empty "$auth_token"
  expect_success "to_number environment variable should be set" is_not_empty "$to_number"
  expect_error "from_number environment variable should NOT be set" is_not_empty "$from_number"
  expect_success "message environment variable should be set" is_not_empty "$message"
	expect_success "sms_media environment variable should be set" is_not_empty "$sms_media"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with message not set,
# it should raise an error message and exit
#
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export account_sid="dsa4321"
  export auth_token="dsa4321"
  export to_number="dsa4321"
  export from_number="dsa4321"
  export sms_media="dsa4321"

  # All env vars should exist except message
  expect_success "account_sid environment variable should be set" is_not_empty "$account_sid"
  expect_success "auth_token environment variable should be set" is_not_empty "$auth_token"
  expect_success "to_number environment variable should be set" is_not_empty "$to_number"
  expect_success "from_number environment variable should be set" is_not_empty "$from_number"
  expect_error "message environment variable should NOT be set" is_not_empty "$message"
	expect_success "sms_media environment variable should be set" is_not_empty "$sms_media"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# --------------------
# --- Test Results ---

echo
echo "--- Results ---"
echo " * Errors: $test_results_error_count"
echo " * Success: $test_results_success_count"
echo "---------------"

if [ $test_results_error_count -eq 0 ]; then
  echo "-> SUCCESS"
else
  echo "-> FAILED"
fi
