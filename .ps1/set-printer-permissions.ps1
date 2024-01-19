#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
# 
# __________        .__        __                        __________                     .__              .__                      
# \______   \_______|__| _____/  |_  ___________         \______   \ ___________  _____ |__| ______ _____|__| ____   ____   ______
#  |     ___/\_  __ \  |/    \   __\/ __ \_  __ \  ______ |     ___// __ \_  __ \/     \|  |/  ___//  ___/  |/  _ \ /    \ /  ___/
#  |    |     |  | \/  |   |  \  | \  ___/|  | \/ /_____/ |    |   \  ___/|  | \/  Y Y  \  |\___ \ \___ \|  (  <_> )   |  \\___ \ 
#  |____|     |__|  |__|___|  /__|  \___  >__|            |____|    \___  >__|  |__|_|  /__/____  >____  >__|\____/|___|  /____  >
#                           \/          \/                              \/            \/        \/     \/               \/     \/ 
# 
#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

# Uncomment Block to use

# --- BLOCK 1 ---
# # Add specific User to specific Printer on specific server with "Print" and "Manage Document Permissions
# Path\to\location\Set-PrinterPermissions.ps1 -ServerName $env:COMPUTERNAME -SinglePrinterName "<PRINTER_NAME>" -AccountName "<USER_NAME>" -AccessMask Print -NoLog
# Path\to\location\Set-PrinterPermissions.ps1 -ServerName $env:COMPUTERNAME -SinglePrinterName "<PRINTER_NAME>" -AccountName "<USER_NAME>" -AccessMask ManageDocuments -NoLog

# --- BLOCK 2 ---
# # Add specific User to ALL printers on a specific server with "Print" and "Manage Document Permissions
# Path\to\location\Set-PrinterPermissions.ps1 -ServerName $env:COMPUTERNAME -AccountName "<USER_NAME>" -AccessMask Print
# Path\to\location\Set-PrinterPermissions.ps1 -ServerName $env:COMPUTERNAME -AccountName "<USER_NAME>" -AccessMask ManageDocuments

# --- BLOCK 3 ---
# # Remove specific User from specific Printer on specific server
# C:\TMG\PrinterSetup\Scripts\Set-PrinterPermissions.ps1 -ServerName $env:COMPUTERNAME -SinglePrinterName "<PRINTER_NAME>" -AccountName "<USER_NAME>" -Remove -NoLog

# --- END SCRIPT ---