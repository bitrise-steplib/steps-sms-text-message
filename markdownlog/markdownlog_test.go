package markdownlog

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"testing"
)

const (
	REFERENCE_LOG_FILE_PATH               string = "./_test_logs/LogReference.md"
	REFERENCE_SECTION_LOG_FILE_PATH       string = "./_test_logs/LogSectionReference.md"
	REFERENCE_SECTION_START_LOG_FILE_PATH string = "./_test_logs/LogSectionStartReference.md"

	LOG_TEST_FILE_PATH          string = "./_test_logs/LogTest.md"
	LOG_SECTION_TEST_FILE_PATH  string = "./_test_logs/LogSectionTest.md"
	LOG_SECTION_START_FILE_PATH string = "./_test_logs/LogSectionStartTest.md"
)

func IsPathExists(pth string) (bool, error) {
	if pth == "" {
		return false, errors.New("No path provided")
	}
	_, err := os.Stat(pth)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func TestClearLogFile(t *testing.T) {
	t.Log("Should remove LogFileTest.md")

	Setup(LOG_TEST_FILE_PATH)

	if pth != LOG_TEST_FILE_PATH {
		t.Error("Log path setup failed")
	}

	ClearLogFile()

	if exist, _ := IsPathExists(pth); exist {
		t.Error("Failed to clear LogFileTest.md")
	}
}

func TestMessageToOutput(t *testing.T) {
	t.Log("LogReference.md should be same as LogTest.md")

	Setup(LOG_TEST_FILE_PATH)
	if pth != LOG_TEST_FILE_PATH {
		t.Error("Log path setup failed")
	}

	ClearLogFile()
	if exist, _ := IsPathExists(pth); exist {
		t.Error("Failed to clear LogFileTest.md")
	}

	// Read reference log file
	content, err := ioutil.ReadFile(REFERENCE_LOG_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	refLog := string(content)

	// Generate test log file
	testlog := generateTestMessage()
	MessageToOutput(testlog)
	content, err = ioutil.ReadFile(LOG_TEST_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	testlog = string(content)

	if refLog != testlog {
		t.Error("Wrong log file format")
	}
}

func TestSectionToOutput(t *testing.T) {
	t.Log("LogSectionReference.md should be same as LogTest.md")

	Setup(LOG_SECTION_TEST_FILE_PATH)
	if pth != LOG_SECTION_TEST_FILE_PATH {
		t.Error("Log path setup failed")
	}

	ClearLogFile()
	if exist, _ := IsPathExists(pth); exist {
		t.Error("Failed to clear LogFileTest.md")
	}

	// Read reference log file
	content, err := ioutil.ReadFile(REFERENCE_SECTION_LOG_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	refLog := string(content)

	// Generate test log file
	testlog := generateTestMessage()
	SectionToOutput(testlog)
	content, err = ioutil.ReadFile(LOG_SECTION_TEST_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	testlog = string(content)

	if refLog != testlog {
		t.Error("Wrong log file format")

		fmt.Println("Reference: ")
		fmt.Print(refLog)
		fmt.Println("Generated:")
		fmt.Print(testlog)
	}
}

func TestSectionStartToOutput(t *testing.T) {
	t.Log("LogSectionStartReference.md should be same as LogTest.md")

	Setup(LOG_SECTION_START_FILE_PATH)
	if pth != LOG_SECTION_START_FILE_PATH {
		t.Error("Log path setup failed")
	}

	ClearLogFile()
	if exist, _ := IsPathExists(pth); exist {
		t.Error("Failed to clear LogFileTest.md")
	}

	// Read reference log file
	content, err := ioutil.ReadFile(REFERENCE_SECTION_START_LOG_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	refLog := string(content)

	// Generate test log file
	testlog := generateTestMessage()
	SectionStartToOutput(testlog)
	content, err = ioutil.ReadFile(LOG_SECTION_START_FILE_PATH)
	if err != nil {
		t.Error("Failed to open reference log file:", err)
	}
	testlog = string(content)

	if refLog != testlog {
		t.Error("Wrong log file format")

		fmt.Println("Reference: ")
		fmt.Print(refLog)
		fmt.Println("Generated:")
		fmt.Print(testlog)
	}
}

func generateTestMessage() string {
	message := "Message successfully sent!\n"
	message = message + "From:\n"
	message = message + "Krissz" + "\n"
	message = message + "To Romm:\n"
	message = message + "12345" + "\n"
	message = message + "Message:\n"
	message = message + "Test"

	return message
}
