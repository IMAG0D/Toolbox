#NoEnv  ;
#Warn  ;
SendMode Input  ;
SetWorkingDir %A_ScriptDir%  ;

!0::
Run cmd /k ipconfig /flushdns
Run cmd /k ipconfig /release
Run cmd /k ipconfig /renew

return
