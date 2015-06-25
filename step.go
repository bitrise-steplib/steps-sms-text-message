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
	fmt.Println("LogPath:", pth)

	// input validation
	// required
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
	// optional
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

	// Performing request
	urlStr := "https://api.twilio.com/2010-04-01/Accounts/" + accountSid + "/Messages.json"

	// Build out the data for our message
	v := url.Values{}
	v.Set("To", toNumber)
	v.Set("From", fromNumber)
	v.Set("Body", message)
	rb := *strings.NewReader(v.Encode())

	// Create client
	client := &http.Client{}

	req, _ := http.NewRequest("POST", urlStr, &rb)
	req.SetBasicAuth(accountSid, authToken)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	// Make request
	resp, _ := client.Do(req)
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		fmt.Println(resp.Status)
		successMessageToOutput(fromNumber, toNumber, message)

		var data map[string]interface{}
		bodyBytes, _ := ioutil.ReadAll(resp.Body)
		err := json.Unmarshal(bodyBytes, &data)
		if err == nil {
			fmt.Println(data["sid"])

		}
	} else {
		fmt.Println(resp.Status)
		os.Exit(1)
	}
}
