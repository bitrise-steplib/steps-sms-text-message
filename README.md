# Smt Text Message with Twilio

The new Smt Text Message with Twilio step.

SMS Text Message Sender using https://www.twilio.com/
To use their service you have to register first. It is possible to register a trial account for free.
You can find all the required information on the DashBoard tab and the Numbers tab.

Important! https://www.twilio.com/help/faq/sms/when-i-send-an-sms-message-through-twilio-does-the-recipient-of-my-sms-message-get-charged


Can be run directly with the [bitrise CLI](https://github.com/bitrise-io/bitrise),
just `git clone` this repository, `cd` into it's folder in your Terminal/Command Line
and call `bitrise run test`.

*Check the `bitrise.yml` file for required inputs which have to be
added to your `.bitrise.secrets.yml` file!*


# Input Environment Variables
- account_sid
- auth_token
- to_number			# in E.164 format http://en.wikipedia.org/wiki/E.164 (i.e. without hyphens)
- from_number		# in E.164 format http://en.wikipedia.org/wiki/E.164 (i.e. without hyphens)
- message
- sms_media				# optional
