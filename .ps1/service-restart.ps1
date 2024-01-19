#----------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------
# 
#   _________                         .__                                                __                 __   
#  /   _____/ ___________   _______  _|__| ____  ____           _______   ____   _______/  |______ ________/  |_ 
#  \_____  \_/ __ \_  __ \_/ ___\  \/ /  |/ ___\/ __ \   ______ \_  __ \_/ __ \ /  ___/\   __\__  \\_  __ \   __\
#  /        \  ___/|  | \/\  \___\   /|  \  \__\  ___/  /_____/  |  | \/\  ___/ \___ \  |  |  / __ \|  | \/|  |  
# /_______  /\___  >__|    \___  >\_/ |__|\___  >___  >          |__|    \___  >____  > |__| (____  /__|   |__|  
#         \/     \/            \/             \/    \/                       \/     \/            \/             
# 
#----------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

Set-ExecutionPolicy Bypass

function Start-Service {

    param (
        [string]$sName
    )

    $service = Get-Service -Name $sName

    Write-Host "Starting the service..."
    Start-Service -Name $sName

    if ($service.Status -eq 'Running') {
        $isSuccessful = "successfully"  
    } else {
        $isSuccessful = "unsuccessfully"  
    }
    return $isSuccessful
}


$serviceName = "ServiceName"

# --- PG BLOCK START ---
# Uncomment block if service also runs an .exe
# $programName = "PgName"  


# # Get the PID of the program if it is running
# $runningProcess = Get-Process -Name $programName -ErrorAction SilentlyContinue
# if ($runningProcess) {
#     $pidToKill = $runningProcess.Id
#     Write-Host "Killing the program with PID $pidToKill..."
#     Stop-Process -Id $pidToKill -Force
#     Start-Sleep -Seconds 2
# }
# --- PG BLOCK END ---

# Stop the service if it is running
if ($service.Status -eq 'Running') {
    Write-Host "Stopping the service..."
    Stop-Service -Name $serviceName
    Start-Sleep -Seconds 5
    $flag = Start-MTService -sName $serviceName
    Write-Host "Service restarted $flag."        
} else {
    $flag = Start-MTService -sName $serviceName
    $flag = "successfully"
    Write-Host "Service restarted successfully."        
}

# Log information
$logFile = "C:\TMG\Scripts\MTSSRestartLog.txt"
$logMessage = "{0:yyyy-MM-dd HH:mm:ss} - Script $flag run" -f (Get-Date)

Add-Content -Path $logFile -Value $logMessage -Force

# --- END SCRIPT ---