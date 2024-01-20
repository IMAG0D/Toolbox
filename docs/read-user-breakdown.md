# read-user-breakdown

Script process flow

<div id="bkmrk-user-runs-read-user."><div>- User runs read-user.bat
- .bat calls PowerShell process and runs read-user.ps1 (with arguments to hide terminal)
- Script calls XAML based window
- User copies in email then selects username style and confirms \[OMITTED FOR PRIVACY REASONS\]
- User confirms
- Script reads email line by line
- Extraction logic compares line against template parameters and pulls:
- - users display name - users Job title - users email \*\*if present
- Script Generates random 8 character Password containing 1 Uppercase, 1 Number, 1
- Symbol and 5 lowercase letters
- Script creates username based on users selection of username style (First.Last or FirstL)
- Script error checks username for more than 20 characters and prompts user to shorten last name
- Script creates user object
- Script passes user object and \[OMITTED FOR PRIVACY REASONS\]
- Function calls another window to confirm extracted user details
- User confirms
- Script checks for excel or libre processes and kills them (can't write to open csv)
- Script has 5 attempts to write user object to CSV by:
- - getting the first line (CSV headers)
- - overwriting all contents of the csv with just the first line
- - appending the user object data to the Users.csv
- Script calls ImportUser.ps1 and starts PowerShell process with hidden argument
- Script writes necessary New User info to the input text box for the user to copy in to their customer email
- User can close/copy in another user email

</div></div>Limitations:

<div id="bkmrk-developed-with-limit"><div>- Developed with limited PowerShell scripting knowledge
- OOP best practices not observed
- No exceptions handled (script is called via a .bat with arguments to hide terminal errors)
- No script logging
- No troubleshooting elements

</div></div>Features:

<div id="bkmrk-most-common-errors-t">- Most common errors that users will come across have been accounted for as mentioned above
- No need for user to clear out old csv entries, script will overwrite old data
- No need for user to close pre-opened csv's

</div>