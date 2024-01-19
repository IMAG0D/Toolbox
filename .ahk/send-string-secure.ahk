#NoEnv  ;
#Warn  ;
SendMode Input  ;
SetWorkingDir %A_ScriptDir%  ;

; Press Alt + F1 to trigger the script
!F1::

; Set the path to your text file
FilePath := "Path\To\Location\SecureString.txt"

; Open the file for reading
FileRead, FileContents, %FilePath%

; Check if the file was successfully read
if ErrorLevel
{
    MsgBox, Failed to read the file.
    ExitApp
}

; init int var x2
SET_NUMBER := 73
STRING_LENGTH := 56

; Check if the file contains at least %SET_NUMBER% characters
if StrLen(FileContents) < 73
{
    MsgBox, The file is too short to extract %STRING_LENGTH% characters starting from the %SET_NUMBER% character.
    ExitApp
}

; Extraction
ExtractedText := SubStr(FileContents, %SET_NUMBER%, %STRING_LENGTH%)

; Send Extracted
SendInput %ExtractedText%

return
