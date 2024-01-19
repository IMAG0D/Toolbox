﻿#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
# 
# ___.   .__                                             .__              .__                      
# \_ |__ |__| ____           ______   ___________  _____ |__| ______ _____|__| ____   ____   ______
#  | __ \|  |/    \   ______ \____ \_/ __ \_  __ \/     \|  |/  ___//  ___/  |/  _ \ /    \ /  ___/
#  | \_\ \  |   |  \ /_____/ |  |_> >  ___/|  | \/  Y Y  \  |\___ \ \___ \|  (  <_> )   |  \\___ \ 
#  |___  /__|___|  /         |   __/ \___  >__|  |__|_|  /__/____  >____  >__|\____/|___|  /____  >
#      \/        \/          |__|        \/            \/        \/     \/               \/     \/ 
# 
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

$ProfilePaths = GCI C:\users | Select -ExpandProperty FullName
Foreach ($Path in $ProfilePaths)
{
Write-Host "$Path\`$RECYCLE.BIN"
icacls "$Path\`$RECYCLE.BIN" /Reset /T
}

# --- END SCRIPT ---