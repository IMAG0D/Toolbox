; Press Alt + F2 to trigger the script
!F2::
    ; Set the values to send
    string1 := Test1
    string2 := Test2
    
    ; Type in the string1
    SendInput %string1%
    
    ; Press Tab to move field in focus
    SendInput {Tab}
    
    ; Type in the string2
    SendInput %string2%
    
    ; Press Enter to submit the form
    SendInput {Enter}
return
