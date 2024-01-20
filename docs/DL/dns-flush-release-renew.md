# dns-flush-release-renew

<p class="callout info">**Requirements:**  
- **AutoHotkey** Installed *([see resources](https://github.com/IMAG0D/Toolbox/tree/main/resources))*  
- **dns-flush-release-renew.ahk** in a "Running" state *([see .ahk](https://github.com/IMAG0D/Toolbox/tree/main/.ahk))*</p>

Simple script to run the following cmd commands in sequence using the hotkey assigned at the beginning of the script:

- ipconfig /flushdns
- ipconfig /release
- ipconfig /renew