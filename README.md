steps-sms-text-message
======================

SMS Text Message Sender using [https://www.twilio.com/](https://www.twilio.com/)

To use their service you have to register first. It is possible to register a trial account for free.

You can find all the required information on the DashBoard tab and the Numbers tab.

Important! [Info about resipient charging](https://www.twilio.com/help/faq/sms/when-i-send-an-sms-message-through-twilio-does-the-recipient-of-my-sms-message-get-charged)

This Step is part of the [Open StepLib](http://www.steplib.com/), you can find its StepLib page [here](http://www.steplib.com/step/twilio-sms-text-message)

# Input Environment Variables
- **TWILIO_ACCOUNT_SID**

    at [https://www.twilio.com/user/account](https://www.twilio.com/user/account)
- **TWILIO_AUTH_TOKEN**

	at [https://www.twilio.com/user/account](https://www.twilio.com/user/account)
- **TWILIO_SMS_TO_NUMBER**

	in E.164 format [http://en.wikipedia.org/wiki/E.164](http://en.wikipedia.org/wiki/E.164) (i.e. without hyphens)
- **TWILIO_SMS_FROM_NUMBER**

	at [https://www.twilio.com/user/account](https://www.twilio.com/user/account) > Numbers; in E.164 format [http://en.wikipedia.org/wiki/E.164](http://en.wikipedia.org/wiki/E.164) (i.e. without hyphens)
- **TWILIO_SMS_MESSAGE**

	the text message you would like to send
- **TWILIO_SMS_MEDIA**

	optional

# How to test/run locally?

- clone this repository
- cd into the repository folder
- run: TWILIO_ACCOUNT_SID=[your-account-sid] TWILIO_AUTH_TOKEN=[your-auth-token] TWILIO_SMS_TO_NUMBER=[the-phone-number-of-the-receiver] TWILIO_SMS_FROM_NUMBER=[your-twilio-phone-number] TWILIO_SMS_MESSAGE="This is a test message." bash step.sh
