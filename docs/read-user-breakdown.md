# read-user-breakdown

1. User runs read-user.bat
2. .bat calls PowerShell process and runs read-user.ps1 (with arguments to hide terminal)
3. Script calls XAML based window
4. User copies in email then selects username style and confirms \[OMITTED FOR PRIVACY REASONS\]
5. User confirms
6. Script reads email line by line
7. Extraction logic compares line against template parameters and pulls:  
    \- *users display name* - users Job title - *users email* *\*\*if present*
8. Script Generates random 8 character Password containing 1 Uppercase, 1 Number, 1 Symbol and 5 lowercase letters
9. Script creates username based on users selection of username style (First.Last or FirstL)
10. Script error checks username for more than 20 characters and prompts user to shorten last name
11. Script creates user object
12. Script passes user object and \[OMITTED FOR PRIVACY REASONS\]
13. Function calls another window to confirm extracted user details
14. User confirms
15. Script checks for excel or libre processes and kills them (can't write to open csv)
16. Script has 5 attempts to write user object to CSV by:  
    \- getting the first line (CSV headers)  
    \- overwriting all contents of the csv with just the first line  
    \- appending the user object data to the Users.csv
17. Script calls ImportUser.ps1 and starts PowerShell process with hidden argument
18. Script writes necessary New User info to the input text box for the user to copy in to their customer email
19. User can close/copy in another user email
#
Limitations:  
- Developed with limited PowerShell scripting knowledge  
- OOP best practices not observed  
- No exceptions handled (script is called via a .bat with arguments to hide terminal errors)  
- No script logging  
- No troubleshooting elements  
#
Features:  
- most common errors that users will come across have been accounted for as mentioned above  
- no need for user to clear out old csv entries, script will overwrite old data  
- no need for user to close pre-opened csv's