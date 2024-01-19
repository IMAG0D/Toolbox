@echo off
taskkill /im ProcessName.exe /f
pushd Path\To\Location\
ProcessName.exe A1
popd
exit