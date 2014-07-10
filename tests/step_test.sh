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
  unset TWILIO_ACCOUNT_SID
	unset TWILIO_AUTH_TOKEN
	unset TWILIO_SMS_TO_NUMBER
	unset TWILIO_SMS_FROM_NUMBER
	unset TWILIO_SMS_MESSAGE
	unset TWILIO_SMS_MEDIA
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

# [TEST] Call the command with the minimum required parameters given, 
# it should execute, but curl should return with authentication error
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_ACCOUNT_SID="asd1234"
  export TWILIO_AUTH_TOKEN="dsa4321"
  export TWILIO_SMS_TO_NUMBER="dsa4321"
  export TWILIO_SMS_FROM_NUMBER="dsa4321"
  export TWILIO_SMS_MESSAGE="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist
  expect_success "TWILIO_ACCOUNT_SID environment variable should be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_success "TWILIO_AUTH_TOKEN environment variable should be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_success "TWILIO_SMS_TO_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_success "TWILIO_SMS_FROM_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_success "TWILIO_SMS_MESSAGE environment variable should be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result

# [TEST] Call the command with TWILIO_ACCOUNT_SID not set, 
# it should raise an error message and exit
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_AUTH_TOKEN="dsa4321"
  export TWILIO_SMS_TO_NUMBER="dsa4321"
  export TWILIO_SMS_FROM_NUMBER="dsa4321"
  export TWILIO_SMS_MESSAGE="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist except TWILIO_ACCOUNT_SID
  expect_error "TWILIO_ACCOUNT_SID environment variable should NOT be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_success "TWILIO_AUTH_TOKEN environment variable should be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_success "TWILIO_SMS_TO_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_success "TWILIO_SMS_FROM_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_success "TWILIO_SMS_MESSAGE environment variable should be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with TWILIO_AUTH_TOKEN not set, 
# it should raise an error message and exit
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_ACCOUNT_SID="dsa4321"
  export TWILIO_SMS_TO_NUMBER="dsa4321"
  export TWILIO_SMS_FROM_NUMBER="dsa4321"
  export TWILIO_SMS_MESSAGE="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist except TWILIO_AUTH_TOKEN
  expect_success "TWILIO_ACCOUNT_SID environment variable should be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_error "TWILIO_AUTH_TOKEN environment variable should NOT be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_success "TWILIO_SMS_TO_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_success "TWILIO_SMS_FROM_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_success "TWILIO_SMS_MESSAGE environment variable should be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with TWILIO_SMS_TO_NUMBER not set, 
# it should raise an error message and exit
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_ACCOUNT_SID="dsa4321"
  export TWILIO_AUTH_TOKEN="dsa4321"
  export TWILIO_SMS_FROM_NUMBER="dsa4321"
  export TWILIO_SMS_MESSAGE="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist except TWILIO_SMS_TO_NUMBER
  expect_success "TWILIO_ACCOUNT_SID environment variable should be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_success "TWILIO_AUTH_TOKEN environment variable should be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_error "TWILIO_SMS_TO_NUMBER environment variable should NOT be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_success "TWILIO_SMS_FROM_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_success "TWILIO_SMS_MESSAGE environment variable should be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with TWILIO_SMS_FROM_NUMBER not set, 
# it should raise an error message and exit
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_ACCOUNT_SID="dsa4321"
  export TWILIO_AUTH_TOKEN="dsa4321"
  export TWILIO_SMS_TO_NUMBER="dsa4321"
  export TWILIO_SMS_MESSAGE="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist except TWILIO_SMS_FROM_NUMBER
  expect_success "TWILIO_ACCOUNT_SID environment variable should be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_success "TWILIO_AUTH_TOKEN environment variable should be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_success "TWILIO_SMS_TO_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_error "TWILIO_SMS_FROM_NUMBER environment variable should NOT be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_success "TWILIO_SMS_MESSAGE environment variable should be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

  # Send sms request
  expect_error "The command should be called, but should not complete sucessfully" print_and_do_command ./step.sh
)
test_result=$?
inspect_test_result $test_result


# [TEST] Call the command with TWILIO_SMS_MESSAGE not set, 
# it should raise an error message and exit
# 
(
  print_new_test
  test_env_cleanup

  # Set env vars
  export TWILIO_ACCOUNT_SID="dsa4321"
  export TWILIO_AUTH_TOKEN="dsa4321"
  export TWILIO_SMS_TO_NUMBER="dsa4321"
  export TWILIO_SMS_FROM_NUMBER="dsa4321"
  export TWILIO_SMS_MEDIA="dsa4321"

  # All env vars should exist except TWILIO_SMS_MESSAGE
  expect_success "TWILIO_ACCOUNT_SID environment variable should be set" is_not_empty "$TWILIO_ACCOUNT_SID"
  expect_success "TWILIO_AUTH_TOKEN environment variable should be set" is_not_empty "$TWILIO_AUTH_TOKEN"
  expect_success "TWILIO_SMS_TO_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_TO_NUMBER"
  expect_success "TWILIO_SMS_FROM_NUMBER environment variable should be set" is_not_empty "$TWILIO_SMS_FROM_NUMBER"
  expect_error "TWILIO_SMS_MESSAGE environment variable should NOT be set" is_not_empty "$TWILIO_SMS_MESSAGE"
	expect_success "TWILIO_SMS_MEDIA environment variable should be set" is_not_empty "$TWILIO_SMS_MEDIA"

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
