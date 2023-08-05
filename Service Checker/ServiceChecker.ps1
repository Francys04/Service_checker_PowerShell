# Send alert message
Import-Module "C:\Users\Phantom\Desktop\powershell-projects\Service Checker\mail_module.psm1"
$MailAccount=Import-Clixml -Path "C:\Users\Phantom\Desktop\powershell-projects\Service Checker\gmail.xml"
$MailPort=587
$MailSMTPServer="smtp.gmail.com"
$MailFrom=$MailAccount.Username
$MailTo="alexmorohai1997@gmail.com"

# create variables
$ServiceFilePath="C:\Users\Phantom\Desktop\powershell-projects\Service Checker\Service.csv"
# create log path
$logPath="C:\Users\Phantom\Desktop\powershell-projects\Service Checker"
$LogFile="Services-$(Get-Date -Format "yyyy-MM-dd hh-mm").txt"

$ServicesList=Import-Csv -Path $ServiceFilePath -Delimiter ','



#verify if services running or not and check this by run and stop (manually) from servises_locals
foreach($Service in $ServicesList){
    $CurrentServiceStatus=(Get-Service -Name $Service.Name).Status

    if($Service.Status -ne $CurrentServiceStatus){
        $Log="Service : $($Service.Name) is currently $CurrentServiceStatus, should be $($Service.Status)"
        Write-Output $Log
        # log into in files
        Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log

        $Log="Setting $($Service.Name) to $($Service.Status)"
        Write-Output $Log
        Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
        Set-Service -Name $Service.Name -Status $Service.Status


        $AfterServiceStatus=(Get-Service -Name $Service.Name).Status
        if($Service.Status -eq $AfterServiceStatus){
            $Log="Action was succesuful Service $($Service.Name) is now $AfterServiceStatus"
            Write-Output $Log
            Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
        }
        else {
            $Log="Action was succesuful Service $($Service.Name) is now $AfterServiceStatus should be $($Service.Status)"
            Write-Output $Log
            Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
        }
    }
}

# #if log file exist
if(Test-Path -Path "$LogPath\$LogFile"){
    $Subject="$($env:COMPUTERNAME) is having issues with services"
    $Body="Here is the log file"
    $Attachement="$LogPath\$LogFile"
    Send-MailKitMessage -From $MailFrom -To $MailTo -SmtpServer $MailSMTPServer -Port $MailPort -Credential $MailAccount -Subject $Subject -Body $Body -Attachments $Attachement
}