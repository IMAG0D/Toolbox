#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#   ________        __ __________        .__        __                       
#  /  _____/  _____/  |\______   \_______|__| _____/  |_  ___________  ______
# /   \  ____/ __ \   __\     ___/\_  __ \  |/    \   __\/ __ \_  __ \/  ___/
# \    \_\  \  ___/|  | |    |     |  | \/  |   |  \  | \  ___/|  | \/\___ \ 
#  \______  /\___  >__| |____|     |__|  |__|___|  /__|  \___  >__|  /____  >
#         \/     \/                              \/          \/           \/ 
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

# Get a list of printer objects
$printers = Get-WmiObject Win32_Printer

# Create an array to store printer information
$printerInfo = foreach ($printer in $printers) {
    $port = if ($printer.PortName -match "^\\\\") { "Shared Network Port: $($printer.PortName)" }
            else { 
                $portObject = Get-WmiObject Win32_TCPIPPrinterPort | Where-Object { $_.Name -eq $printer.PortName }
                if ($portObject) { $portObject.HostAddress }
                else { "Local Port: $($printer.PortName)" }
            }
    
    [PSCustomObject]@{
        PrinterName = $printer.Name
        Port = $port
        Driver = $printer.DriverName
    }
}

# Sort the array by printer name
$sortedPrinters = $printerInfo | Sort-Object PrinterName

# Display the sorted printer list in a table format
$sortedPrinters | Format-Table -AutoSize PrinterName, Port, Driver

# --- END SCRIPT ---
