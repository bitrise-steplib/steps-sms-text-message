#!/bin/bash

echo
echo "account_sid: $account_sid"
echo "auth_token: $auth_token"
echo "to_number: $to_number"
echo "from_number: $from_number"
echo "message: $message"
echo "sms_media: $sms_media"

# Required input validation
# Account SID
if [[ ! $account_sid ]]; then
	echo
    echo "No Account SID provided as environment variable. Terminating..."
    echo
    exit 1
fi

# Auth Token
if [[ ! $auth_token ]]; then
	echo
    echo "No Auth Token provided as environment variable. Terminating..."
    echo
    exit 1
fi

# send to num
if [[ ! $to_number ]]; then
	echo
    echo "No phone number provided where to send the sms as environment variable. Terminating..."
    echo
    exit 1
fi

# send from num
if [[ ! $from_number ]]; then
	echo
    echo "No phone number provided where the sms is coming from as environment variable. Terminating..."
    echo
    exit 1
fi

# message
if [[ ! $message ]]; then
	echo
    echo "No text message provided as environment variable. Terminating..."
    echo
    exit 1
fi

######################

res=$(curl -is -X POST "https://api.twilio.com/2010-04-01/Accounts/$account_sid/Messages.json" \
--data-urlencode "To=$to_number"  \
--data-urlencode "From=$from_number"  \
--data-urlencode "Body=$message" \
--data-urlencode "Media=$sms_media" \
-u $account_sid:$auth_token)

echo
echo " --- Result ---"
echo "$res"
echo " --------------"

http_code=$(echo "$res" | grep HTTP/ | awk {'print $2'} | tail -1)
echo " [i] http_code: $http_code"

if [ "$http_code" == "201" ]; then
  exit 0
else
  exit 1
fi
