@echo off
:: Get the directory of the batch script
set "script_dir=%~dp0"

:: Run the script
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "Path\To\Location\read-user.ps1"