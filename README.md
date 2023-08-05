# Service Checker and Email Alert Script
- This PowerShell script is designed to monitor the status of services listed in a CSV file, record any status changes in a log file, and send email alerts using the MailKit library if any service statuses do not match the expected status.

## Features
- Checks the status of specified services and compares them to the expected status.
- Logs service status changes along with timestamps.
- Sends email alerts with a log file attachment if service status mismatches are detected.
## Requirements
- PowerShell 5.1 or later
- MailKit library (MimeKit and MailKit DLLs)
## Installation and Usage
- Download the script files and the required MailKit library DLLs.
- Open the script in a text editor or PowerShell ISE.
### Step 1: Configure MailKit
- Modify the following lines to set up your email account details in the script:
```
$MailAccount = Import-Clixml -Path "path-to-gmail.xml"
$MailPort = 587
$MailSMTPServer = "smtp.gmail.com"
$MailFrom = $MailAccount.Username
$MailTo = "your-email@example.com"
```
### Step 2: Set Service File Path
- Set the path to your service CSV file:

```$ServiceFilePath = "path-to\Service.csv"```

### Step 3: Specify Log Path
- Set the log file path:
```
$logPath = "path-to-logs"
```
### Step 4: Run the Script
- Open PowerShell and navigate to the directory where the script is located.
- Run the script using the following command:
```.\ServiceCheckerAndAlert.ps1```

## CSV File Format
- The CSV file should contain the list of services to monitor. Each row should have the following format:
```
Name,Status
ServiceName1,Running
ServiceName2,Stopped
Name: The name of the service.
Status: The expected status of the service (Running or Stopped).
```

## Log Files
- Log files are generated with filenames in the format Services-yyyy-MM-dd hh-mm.txt.

## Email Alerts
- If any service status mismatches are detected, an email alert will be sent to the specified recipient. The alert will contain information about the services with status changes and include a log file as an attachment.

## Notes
- This script assumes that the necessary MailKit DLLs are available at the specified paths.
- Make sure to secure your email account credentials and follow best practices for handling sensitive information.
## Disclaimer
- This script is provided as-is, and the author is not responsible for any damages or issues that may arise from its use. Please test the script in a controlled environment before deploying it in a production setting.
