package markdownlog

import (
	"fmt"
	"os"
	"strings"
)

var pth string

func Setup(logPath string) {
	pth = logPath
}

func ClearLogFile() error {
	if pth != "" {
		err := os.Remove(pth)
		if err != nil {
			return err
		}

		fmt.Println("Log file cleared")
	} else {
		fmt.Errorf("No log path defined!")
	}

	return nil
}

func ErrorMessageToOutput(msg string) error {
	if pth != "" {
		f, err := os.OpenFile(pth, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
		if err != nil {
			return err
		}
		defer func() error {
			err := f.Close()
			if err != nil {
				return err
			}

			return nil
		}()

		f.Write([]byte(msg))
	} else {
		fmt.Errorf("No log path defined!")
	}

	lines := strings.Split(msg, "\n")
	for _, line := range lines {
		fmt.Println(line)
	}

	return nil
}

func ErrorSectionToOutput(section string) error {
	msg := "\n" + section + "\n"

	return ErrorMessageToOutput(msg)
}

func ErrorSectionStartToOutput(section string) error {
	msg := section + "\n"

	return ErrorMessageToOutput(msg)
}

func MessageToOutput(msg string) error {
	if pth != "" {
		f, err := os.OpenFile(pth, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
		if err != nil {
			return err
		}
		defer func() error {
			err := f.Close()
			if err != nil {
				return err
			}

			return nil
		}()

		f.Write([]byte(msg))
	} else {
		fmt.Errorf("No log path defined!")
	}

	lines := strings.Split(msg, "\n")
	for _, line := range lines {
		fmt.Println(line)
	}

	return nil
}

func SectionToOutput(section string) error {
	msg := "\n" + section + "\n"

	return MessageToOutput(msg)
}

func SectionStartToOutput(section string) error {
	msg := section + "\n"

	return MessageToOutput(msg)
}
