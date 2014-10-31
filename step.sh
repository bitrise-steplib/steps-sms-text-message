#!/bin/bash

formatted_output_file_path="$BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH"

function echo_string_to_formatted_output {
  echo "$1" >> $formatted_output_file_path
}

function write_section_to_formatted_output {
  echo '' >> $formatted_output_file_path
  echo "$1" >> $formatted_output_file_path
  echo '' >> $formatted_output_file_path
}

echo
echo "TWILIO_ACCOUNT_SID: $TWILIO_ACCOUNT_SID"
echo "TWILIO_AUTH_TOKEN: $TWILIO_AUTH_TOKEN"
echo "TWILIO_SMS_TO_NUMBER: $TWILIO_SMS_TO_NUMBER"
echo "TWILIO_SMS_FROM_NUMBER: $TWILIO_SMS_FROM_NUMBER"
echo "TWILIO_SMS_MESSAGE: $TWILIO_SMS_MESSAGE"
echo "TWILIO_SMS_MEDIA: $TWILIO_SMS_MEDIA"

# Required input validation
# Account SID
if [[ ! $TWILIO_ACCOUNT_SID ]]; then
	echo
    echo "No Account SID provided as environment variable. Terminating..."
    echo
    write_section_to_formatted_output "#Error"
    write_section_to_formatted_output "Reason: No account SID."
    exit 1
fi

# Auth Token
if [[ ! $TWILIO_AUTH_TOKEN ]]; then
	echo
    echo "No Auth Token provided as environment variable. Terminating..."
    echo
    write_section_to_formatted_output "#Error"
    write_section_to_formatted_output "Reason: No auth token."
    exit 1
fi

# send to num
if [[ ! $TWILIO_SMS_TO_NUMBER ]]; then
	echo
    echo "No phone number provided where to send the sms as environment variable. Terminating..."
    echo
    write_section_to_formatted_output "#Error"
    write_section_to_formatted_output "Reason: No phone number provided where to send the message."
    exit 1
fi

# send from num
if [[ ! $TWILIO_SMS_FROM_NUMBER ]]; then
	echo
    echo "No phone number provided where the message is coming from as environment variable. Terminating..."
    echo
    write_section_to_formatted_output "#Error"
    write_section_to_formatted_output "Reason: No phone number provided where the message is coming from."
    exit 1
fi

# TWILIO_SMS_MESSAGE
if [[ ! $TWILIO_SMS_MESSAGE ]]; then
	echo
    echo "No text message provided as environment variable. Terminating..."
    echo
    write_section_to_formatted_output "#Error"
    write_section_to_formatted_output "Reason: No message."
    exit 1
fi

######################

res=$(curl -is -X POST "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Messages.json" \
--data-urlencode "To=$TWILIO_SMS_TO_NUMBER"  \
--data-urlencode "From=$TWILIO_SMS_FROM_NUMBER"  \
--data-urlencode "Body=$TWILIO_SMS_MESSAGE" \
--data-urlencode "Media=$TWILIO_SMS_MEDIA" \
-u $TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN)

echo
echo " --- Result ---"
echo "$res"
echo " --------------"

http_code=$(echo "$res" | grep HTTP/ | awk {'print $2'} | tail -1)
echo " [i] http_code: $http_code"

if [ "$http_code" == "201" ]; then
    write_section_to_formatted_output "#Message successfully sent!"
    write_section_to_formatted_output "### From: ${TWILIO_SMS_FROM_NUMBER}"
    write_section_to_formatted_output "### Message:"
    write_section_to_formatted_output "${TWILIO_SMS_MESSAGE}"
    exit 0
else
    write_section_to_formatted_output "#Error ${http_code}"
    write_section_to_formatted_output "Message send failed!"
    exit 1
fi