
## Environment Checker Script
- This PowerShell script, EnvironmentChecker.ps1, is designed to check the status of a list of servers and record their uptime and downtime information in a CSV file. The script performs the following steps:

### Step 1: Configuration
Declare the path to the CSV file containing the server list.
powershell
Copy code
#### Declare path
```$ServerListFilePath = "C:\Users\Phantom\Desktop\powershell-projects\Enviroment_Checker\EnvCheckList.csv"```
### Step 2: Import Server List
Import the server list from the CSV file using comma as the delimiter.
#### Create list with import csv file
$ServerList = Import-Csv -Path $ServerListFilePath -Delimiter ','
#### Step 3: Prepare for Data Export
Create an empty arraylist named $Export to store data for export.

#### Create an array for data export
```$Export = [System.Collections.ArrayList]@()```

#### Step 4: Check Server Status
- Iterate through each server in the imported server list and perform the following actions:
- Capture server properties.
- Test the network connection using Test-Connection cmdlet.
- Record the current date and time.
- Determine if the server is online or offline.
- Calculate downtime duration and time since the last down alert.

### Step 5: Export Data to CSV
- Export the collected data to the same CSV file, overwriting the existing data.

#### Export data in array to CSV
``$Export | Export-Csv -Path $ServerListFilePath -Delimiter ',' -NoTypeInformation
CSV Column Headers``

- The script assumes the following column headers in the CSV file: `"ServerName", "LastStatus", "LastCheckTime", "DownSince", "LastDownAlertTime"`. Ensure that your CSV file follows this format.

### Usage
- Open PowerShell.
- Navigate to the directory containing the script using the cd command.
- Run the script using .\EnvironmentChecker.ps1.
- Monitor the output in the PowerShell console and review the updated CSV file.
##### Note: 
- This script assumes that the Test-Connection cmdlet is available and functioning as expected in your environment. Additionally, ensure that the CSV file path is correctly set to your environment.

### Disclaimer: 
- Use this script responsibly and ensure that you have the necessary permissions to perform network operations and access the specified files.