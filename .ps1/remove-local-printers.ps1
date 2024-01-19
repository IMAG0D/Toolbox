#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
# 
# __________                        __________        .__        __                       
# \______   \ ____   _____          \______   \_______|__| _____/  |_  ___________  ______
#  |       _// __ \ /     \   ______ |     ___/\_  __ \  |/    \   __\/ __ \_  __ \/  ___/
#  |    |   \  ___/|  Y Y  \ /_____/ |    |     |  | \/  |   |  \  | \  ___/|  | \/\___ \ 
#  |____|_  /\___  >__|_|  /         |____|     |__|  |__|___|  /__|  \___  >__|  /____  >
#         \/     \/      \/                                   \/          \/           \/ 
# 
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

# Prompt user for confirmation before starting the script
$confirm = Read-Host "This script will remove all locally installed printers. Are you sure you want to continue? (Y/N)"

if ($confirm -eq "Y") {
    # Get a list of all locally installed printers
    $printers = Get-Printer | Where-Object {$_.Type -eq "Local"}

    # Check if any printers were found
    if ($printers.Count -eq 0) {
        Write-Host "No locally installed printers found."
    }
    else {
        # Loop through each printer and remove it
        foreach ($printer in $printers) {
            Write-Host "Removing printer $($printer.Name)..."
            try {
                Remove-Printer -InputObject $printer -Confirm:$false
                Write-Host "Printer $($printer.Name) removed successfully."
            }
            catch {
                Write-Host "Error removing printer $($printer.Name): $_.Exception.Message"
            }
        }
    }
}
else {
    Write-Host "Script cancelled."
}

# --- END SCRIPT ---