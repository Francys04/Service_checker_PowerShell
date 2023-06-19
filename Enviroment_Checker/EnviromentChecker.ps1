# declare path
$ServerListFilePath = "C:\Users\Phantom\Desktop\powershell-projects\Enviroment_Checker\EnvCheckList.csv"

# create list with import csv file
$ServerList = Import-Csv -Path $ServerListFilePath -Delimiter ','

# create an array for data export

$Export=[System.Collections.ArrayList]@()

#output data of source(IP)
foreach($Server in $ServerList){
    $ServerName=$Sever.ServerName
    $LastStatus = $Sever.LastStatus
    $DownSince=$Server.DownSince
    $LastDownAlert=$Server.LastDownAlertTime

#check status(offline / online)
    $Connection = Test-Connection $Server.Servername -Count 1

    # set the time 
    $DateTime=Get-Date
    # check if vm is online 

    if($Connection.Status -eq "Succes"){
        Write-Output "$($erverName) is online"
        if($LastStatus -ne "Succes"){
            $Server.DownSince=$null
            $Server.LastDownAlertTime=$null
            Write-Output "$ServerName is now online"
        }
    }
    # check if vm is offline || still offline
    else{
        if($LastStatus -eq "Succes"){
             Write-Output "$($ServerName) is now offline"
             $Server.DownSince=$DataTime
             $Server.LastDownAlertTime=$DataTime
        }
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
# export to csv
    $Server.LastStatus=$Connection.Status
    $Server.LastCheckTime=$DateTime
    [void]$Export.add($Server)
}
#export data in array
$Export | Export-Csv -Path $ServerListFilePath -Delimiter ',' -NoTypeInformation
