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
$PrintServer = $env:COMPUTERNAME
$printers = Get-WmiObject win32_printer -ComputerName $PrintServer | 
    Foreach-Object{ 
        $printer = $_.Name
        $port = $_.PortName
        $driver = $_.DriverName
        Get-WmiObject win32_tcpipprinterport -ComputerName $PrintServer | 
            Where-Object { $_.Name -eq $port } | 
            Select-Object @{
                n = "PrinterName"
                e = { $printer }
            },
            HostAddress,
            @{
                n = "DriverName"
                e = { $driver }
            }
    }

# Create an array to store printer information
$printerInfo = @()

# Populate the array with printer names, IPs, and driver names
foreach ($printer in $printers) {
    $printerInfo += [PSCustomObject]@{
        Name = $printer.PrinterName
        IPAddress = $printer.HostAddress -replace "^.*(?=\\\\)|^.*(?=\s)"
        DriverName = $printer.DriverName
    }
}

# Sort the array by IP address
$sortedPrinters = $printerInfo | Sort-Object IPAddress

# Display the sorted printer list with Name, IPAddress, and DriverName
$sortedPrinters | Format-Table -AutoSize

# --- END SCRIPT ---