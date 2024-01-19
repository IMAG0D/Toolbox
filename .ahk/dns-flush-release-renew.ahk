#NoEnv  ;
#Warn  ;
SendMode Input  ;
SetWorkingDir %A_ScriptDir%  ;

!F2::
Run cmd /k ipconfig /flushdns
Run cmd /k ipconfig /release
Run cmd /k ipconfig /renew

return
