package main

import (
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strings"

	"./markdownlog"
)

const BASE_URL string = "https://api.twilio.com/2010-04-01"

var (
	accountSid   string
	authToken    string
	fromNumber   string
	toNumber     string
	message      string
	errorMessage string
)

type Client struct {
	AccountSid string
	AuthToken  string
	Uri        string
}

func NewClient(accountSid, authToken string) Client {
	uri := fmt.Sprintf("%s/Accounts/%s/Messages.json", BASE_URL, accountSid)
	fmt.Println("Client uri:", uri)

	c := Client{AccountSid: accountSid, AuthToken: authToken, Uri: uri}

	return c
}

func urlValuesFromMessageRequest(req MessageRequest) (url.Values, error) {
	payload := url.Values{
		"To":   {req.ToNumber},
		"From": {req.FromNumber},
		"Body": {req.Message},
	}
	return payload, nil
}

func (c *Client) PostMessage(req MessageRequest) error {
	payload, err := urlValuesFromMessageRequest(req)
	if err != nil {
		return err
	}
	response_bytes := *strings.NewReader(payload.Encode())

	/////////

	client := &http.Client{}

	request, _ := http.NewRequest("POST", c.Uri, &response_bytes)
	request.SetBasicAuth(accountSid, authToken)
	request.Header.Add("Accept", "application/json")
	request.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	// Make request
	resp, _ := client.Do(request)
	fmt.Println(resp.Status)
	/////////

	/*
		resp, err := http.PostForm(c.Uri, payload)
		if err != nil {
			return err
		}
		defer resp.Body.Close()
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			return err
		}

		msgResp := &struct{ Status string }{}
		if err := json.Unmarshal(body, msgResp); err != nil {
			return err
		}
		if msgResp.Status != ResponseStatusSent {
			return getError(body)
		}
	*/

	return nil
}

type MessageRequest struct {
	FromNumber string
	ToNumber   string
	Message    string
}

func buildMessageRequest(isBuildFailedMode bool) MessageRequest {
	request := MessageRequest{
		FromNumber: fromNumber,
		ToNumber:   toNumber,
	}

	if isBuildFailedMode {
		if errorMessage == "" {
			fmt.Println("Build failed, but no TWILIO_SMS_ERROR_MESSAGE defined, use default")
		} else {
			message = errorMessage
		}
	}
	request.Message = message

	return request
}

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
	accountSid = os.Getenv("TWILIO_ACCOUNT_SID")
	if accountSid == "" {
		errorMessageToOutput("$TWILIO_ACCOUNT_SID is not provided!")
		os.Exit(1)
	}
	authToken = os.Getenv("TWILIO_AUTH_TOKEN")
	if authToken == "" {
		errorMessageToOutput("$TWILIO_AUTH_TOKEN is not provided!")
		os.Exit(1)
	}
	toNumber = os.Getenv("TWILIO_SMS_TO_NUMBER")
	if toNumber == "" {
		errorMessageToOutput("$TWILIO_SMS_TO_NUMBER is not provided!")
		os.Exit(1)
	}
	fromNumber = os.Getenv("TWILIO_SMS_TO_NUMBER")
	if fromNumber == "" {
		errorMessageToOutput("$TWILIO_SMS_TO_NUMBER is not provided!")
		os.Exit(1)
	}
	message = os.Getenv("TWILIO_SMS_MESSAGE")
	if message == "" {
		errorMessageToOutput("$TWILIO_SMS_MESSAGE is not provided!")
		os.Exit(1)
	}
	// optional
	//TWILIO_SMS_ERROR_MESSAGE
	errorMessage = os.Getenv("TWILIO_SMS_ERROR_MESSAGE")
	if message == "" {
		errorMessageToOutput("$TWILIO_SMS_ERROR_MESSAGE is not provided!")
		os.Exit(1)
	}

	// perform step
	isBuildFailedMode := (os.Getenv("STEPLIB_BUILD_STATUS") != "0")
	req := buildMessageRequest(isBuildFailedMode)
	c := NewClient(accountSid, authToken)
	if err := c.PostMessage(req); err != nil {
		errorMessageToOutput(err.Error())
		os.Exit(1)
	}

	successMessageToOutput(req.FromNumber, req.ToNumber, req.Message)
}
