package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"strings"

	"./markdownlog"
)

func errorMessageToOutput(msg string) error {
	message := "SMS send failed!\n"
	message = message + "Error message:\n"
	message = message + msg

	return markdownlog.ErrorSectionToOutput(message)
}

func successMessageToOutput(from, to, msg string) error {
	message := "SMS successfully sent!\n"
	message = message + "From:\n"
	message = message + from + "\n"
	message = message + "To:\n"
	message = message + to + "\n"
	message = message + "Message:\n"
	message = message + msg

	return markdownlog.SectionToOutput(message)
}

func main() {
	// init / cleanup the formatted output
	pth := os.Getenv("BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH")
	markdownlog.Setup(pth)
	err := markdownlog.ClearLogFile()
	if err != nil {
		fmt.Errorf("Failed to clear log file", err)
	}

	// required inputs
	accountSid := os.Getenv("TWILIO_ACCOUNT_SID")
	if accountSid == "" {
		errorMessageToOutput("$TWILIO_ACCOUNT_SID is not provided!")
		os.Exit(1)
	}
	authToken := os.Getenv("TWILIO_AUTH_TOKEN")
	if authToken == "" {
		errorMessageToOutput("$TWILIO_AUTH_TOKEN is not provided!")
		os.Exit(1)
	}
	toNumber := os.Getenv("TWILIO_SMS_TO_NUMBER")
	if toNumber == "" {
		errorMessageToOutput("$TWILIO_SMS_TO_NUMBER is not provided!")
		os.Exit(1)
	}
	fromNumber := os.Getenv("TWILIO_SMS_FROM_NUMBER")
	if fromNumber == "" {
		errorMessageToOutput("$TWILIO_SMS_FROM_NUMBER is not provided!")
		os.Exit(1)
	}
	message := os.Getenv("TWILIO_SMS_MESSAGE")
	if message == "" {
		errorMessageToOutput("$TWILIO_SMS_MESSAGE is not provided!")
		os.Exit(1)
	}
	// optional inputs
	errorMessage := os.Getenv("TWILIO_SMS_ERROR_MESSAGE")
	if message == "" {
		errorMessageToOutput("$TWILIO_SMS_ERROR_MESSAGE is not provided!")
		os.Exit(1)
	}

	isBuildFailedMode := (os.Getenv("STEPLIB_BUILD_STATUS") != "0")
	if isBuildFailedMode {
		if errorMessage == "" {
			fmt.Errorf("Build failed, but no TWILIO_SMS_ERROR_MESSAGE defined, use default")
		} else {
			message = errorMessage
		}
	}

	// request payload
	values := url.Values{
		"To":   {toNumber},
		"From": {fromNumber},
		"Body": {message},
	}
	valuesReader := *strings.NewReader(values.Encode())

	// request
	url := "https://api.twilio.com/2010-04-01/Accounts/" + accountSid + "/Messages.json"

	request, err := http.NewRequest("POST", url, &valuesReader)
	if err != nil {
		fmt.Println("Failed to create requestuest:", err)
		os.Exit(1)
	}

	request.SetBasicAuth(accountSid, authToken)
	request.Header.Add("Accept", "application/json")
	request.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	// perform request
	client := &http.Client{}
	response, err := client.Do(request)
	if response.StatusCode >= 200 && response.StatusCode < 300 {
		successMessageToOutput(fromNumber, toNumber, message)
	} else {
		var data map[string]interface{}
		bodyBytes, _ := ioutil.ReadAll(response.Body)
		err := json.Unmarshal(bodyBytes, &data)
		if err == nil {
			fmt.Println("Response:", data)
		}

		errorMsg := fmt.Sprintf("Status code: %s Body: %s", response.StatusCode, response.Body)

		//errorMsg := "Status code: " + response.StatusCode + " Body: " + data
		errorMessageToOutput(errorMsg)

		os.Exit(1)
	}
}
