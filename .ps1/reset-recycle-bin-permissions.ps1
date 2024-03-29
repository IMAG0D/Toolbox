﻿#---------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------
# __________.__      __________                     .__              .__                      
# \______   \__| ____\______   \ ___________  _____ |__| ______ _____|__| ____   ____   ______
#  |    |  _/  |/    \|     ___// __ \_  __ \/     \|  |/  ___//  ___/  |/  _ \ /    \ /  ___/
#  |    |   \  |   |  \    |   \  ___/|  | \/  Y Y  \  |\___ \ \___ \|  (  <_> )   |  \\___ \ 
#  |______  /__|___|  /____|    \___  >__|  |__|_|  /__/____  >____  >__|\____/|___|  /____  >
#         \/        \/              \/            \/        \/     \/               \/     \/ 
#---------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

$ProfilePaths = GCI C:\users | Select -ExpandProperty FullName
Foreach ($Path in $ProfilePaths)
{
Write-Host "$Path\`$RECYCLE.BIN"
icacls "$Path\`$RECYCLE.BIN" /Reset /T
}

# --- END SCRIPT ---