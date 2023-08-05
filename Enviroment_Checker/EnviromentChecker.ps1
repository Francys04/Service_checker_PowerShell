# This line sets the path to the CSV file (EnvCheckList.csv) containing the server list.
# Declare path
$ServerListFilePath = "C:\Users\Phantom\Desktop\powershell-projects\Enviroment_Checker\EnvCheckList.csv"

# Create list with import csv file
$ServerList = Import-Csv -Path $ServerListFilePath -Delimiter ','

# Create an array for data export
# Initializes an empty arraylist named $Export to store data for export later.
$Export=[System.Collections.ArrayList]@()

# Output data of source(IP)
# Starts a loop to iterate through each server entry in the imported $ServerList array. Extracts server properties from each entry.
foreach($Server in $ServerList){
    $ServerName=$Sever.ServerName
    $LastStatus = $Sever.LastStatus
    $DownSince=$Server.DownSince
    $LastDownAlert=$Server.LastDownAlertTime

    # Check status(offline / online)
    # Tests the network connection to the server using Test-Connection cmdlet, and stores the result in $Connection.
    $Connection = Test-Connection $Server.Servername -Count 1

    # Gets the current date and time and stores it in $DateTime.
    # Set the time 
    $DateTime=Get-Date

    # Checks if the server is online (Success status) and updates downtime information if the previous status was different.
    # Check if vm is online 
    if($Connection.Status -eq "Succes"){
        Write-Output "$($erverName) is online"
        if($LastStatus -ne "Succes"){
            $Server.DownSince=$null
            $Server.LastDownAlertTime=$null
            Write-Output "$ServerName is now online"
        }
    }
    # Check if vm is offline || still offline
    else{
        if($LastStatus -eq "Succes"){
             Write-Output "$($ServerName) is now offline"
             $Server.DownSince=$DataTime
             $Server.LastDownAlertTime=$DataTime
        }
        # Calculates the duration of downtime and time since the last down alert.
        else{
            # how long is down 
            $DownFor=($(Get-Date -Date $DateTime) - $(Get-Date -Date $DownSince)).TotalDays
            $SinceLastDownAlert=($(Get-Date -Date $DateTime) - $(Get-Date -Date $LastDownAlert)).TotalDays
            if(($DownFor -ge 1) -and ($SinceLastDownAlert -ge 1)){
                Write-Output "It has been $SinceLastDownAlert days since last alert"
                Write-Output "$ServerName is still offline for $DownFor days"
                $Server.LastDownAlertTime=$DateTime
            }
        }
    }
# Export to csv
    $Server.LastStatus=$Connection.Status
    $Server.LastCheckTime=$DateTime
    [void]$Export.add($Server)
}
# Export data in array
$Export | Export-Csv -Path $ServerListFilePath -Delimiter ',' -NoTypeInformation
