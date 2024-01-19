#--------------------------------------------------------------
#--------------------------------------------------------------
# 
# __________                   ._______ ___                    
# \______   \ ____ _____     __| _/    |   \______ ___________ 
#  |       _// __ \\__  \   / __ ||    |   /  ___// __ \_  __ \
#  |    |   \  ___/ / __ \_/ /_/ ||    |  /\___ \\  ___/|  | \/
#  |____|_  /\___  >____  /\____ ||______//____  >\___  >__|   
#         \/     \/     \/      \/             \/     \/       
# 
#--------------------------------------------------------------
#--------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

Add-Type -AssemblyName PresentationFramework

# Password generator function
function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [ValidateRange(4,[int]::MaxValue)]
        [int] $length,
        [int] $upper = 1,
        [int] $lower = 1,
        [int] $numeric = 1,
        [int] $special = 1
    )
    if($upper + $lower + $numeric + $special -gt $length) {
        throw "number of upper/lower/numeric/special char must be lower or equal to length"
    }
    $uCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $lCharSet = "abcdefghijklmnopqrstuvwxyz"
    $nCharSet = "0123456789"
    $sCharSet = "/*-+,!?=()@;:._"
    $charSet = ""
    if($upper -gt 0) { $charSet += $uCharSet }
    if($lower -gt 0) { $charSet += $lCharSet }
    if($numeric -gt 0) { $charSet += $nCharSet }
    if($special -gt 0) { $charSet += $sCharSet }
    
    $charSet = $charSet.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)
    $rng.GetBytes($bytes)
 
    $result = New-Object char[]($length)
    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
    }
    $password = (-join $result)
    $valid = $true
    if($upper   -gt ($password.ToCharArray() | Where-Object {$_ -cin $uCharSet.ToCharArray() }).Count) { $valid = $false }
    if($lower   -gt ($password.ToCharArray() | Where-Object {$_ -cin $lCharSet.ToCharArray() }).Count) { $valid = $false }
    if($numeric -gt ($password.ToCharArray() | Where-Object {$_ -cin $nCharSet.ToCharArray() }).Count) { $valid = $false }
    if($special -gt ($password.ToCharArray() | Where-Object {$_ -cin $sCharSet.ToCharArray() }).Count) { $valid = $false }
 
    if(!$valid) {
         $password = Get-RandomPassword $length $upper $lower $numeric $special
    }
    return $password
}

# Confirmation window function
function Show-ConfirmationWindow {
    param (
        $User,
        $practiceOption
    )

$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Confirmation" Height="275" Width="400">
    <StackPanel>
        <TextBlock TextWrapping="Wrap">
        </TextBlock>
        <TextBlock>
            Are you sure you want to add the user with the following details?
        </TextBlock>
        <TextBlock>
        </TextBlock>
        <TextBlock>
            Username: $($User.username)
        </TextBlock>
        <TextBlock>
            First Name: $($User.firstName)
        </TextBlock>
        <TextBlock>
            Last Name: $($User.lastName)
        </TextBlock>
        <TextBlock>
            Display Name: $($User.displayName)
        </TextBlock>
        <TextBlock>
            Job Title: $($User.jobTitle)
        </TextBlock>
        <TextBlock>
            Email: $($User.email)
        </TextBlock>
        <TextBlock>
            Remote Access: $($User.remoteAccess)
        </TextBlock>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="10">
            <Button Content="OK" Name="ConfirmButton" Width="60" Margin="0,0,10,0"/>
            <Button Content="Back" Name="BackButton" Width="60"/>
        </StackPanel>
    </StackPanel>
</Window>
"@
    
    $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $XAML)
    $confirmationWindow = [Windows.Markup.XamlReader]::Load($reader)
    $ConfirmButton = $confirmationWindow.FindName("ConfirmButton")
    $BackButton = $confirmationWindow.FindName("BackButton")
    
    $ConfirmButton.Add_Click({
    
        # Check if the CSV is open and close it if it is
        $processesToClose = @("Excel", "soffice.bin", "soffice")
    
        # Loop through the process names and stop each process
        foreach ($processName in $processesToClose) {
            $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
            if ($processes.Count -gt 0) {
                Stop-Process -Name $processName -Force
                $processes | Wait-Process
            }
        }
    
        # Write user object to the CSV file until successful
        $csvFilePath = "Path\To\Location\Users.csv"
        $attempts = 0
        $maxAttempts = 5
    
        while ($attempts -lt $maxAttempts) {
            try {
                # Read the first line from the existing CSV file
                $firstLine = Get-Content -Path $csvFilePath -TotalCount 1

                # Write the first line back to the CSV file
                $firstLine | Out-File -FilePath $csvFilePath -Encoding utf8

                # Append the new data starting from the second line
                $user | Export-Csv -Path $csvFilePath -Append -Force -NoTypeInformation

                # Call Import User Script
                $importScriptPath = if ($practiceOption -eq 1) {
                    "Path\To\Location\ImportUser.ps1"
                } else {
                    "Path\To\Location\import-user-alt.ps1"
                }
    
                # Start-Process arguments
                $arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File $importScriptPath"
    
                # Start Import Script process
                Start-Process powershell.exe -ArgumentList $arguments
    
                # Confirmation message
                $InputTextBox.Text = "As requested, $($User.displayName) has been added with the below details:`n`n"
                $InputTextBox.Text += "Username: $($User.username)`n"
                $InputTextBox.Text += "Temporary Computer Password: $($User.password)`n`n"
                $InputTextBox.Text += "Remote Access: $($User.remoteAccess)`n`n"
                $InputTextBox.Text += "Copy these details and then add another user if needed..."

                break
            } catch {
                $attempts++
                Start-Sleep -Seconds 1
            }
        }
    
        $confirmationWindow.Close()
    })
    
    $BackButton.Add_Click({
        $confirmationWindow.Close()
        $window.ShowDialog()
    })
    $confirmationWindow.add_Closing({
        $confirmationWindow.Close()    
        $window.ShowDialog()
    })
    
    $confirmationWindow.ShowDialog()
}

# Main form call block --script start

#*******ALT IMPORT type functionality/naming conventions excluded in this version for privacy**********
$XAMLInput = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Read User" Height="550" Width="400">
    <StackPanel>
        <Label Content="Copy in the New User email:"/>
        <TextBox Name="InputTextBox" Margin="5" Height="300" TextWrapping="Wrap" AcceptsReturn="True"/>
        <Label Content="Choose the Username Style:"/>
        <StackPanel Orientation="Horizontal" Margin="5">
            <RadioButton Content="Firstname.Lastname" IsChecked="True" Name="Option1"/>
            <RadioButton Content="FirstnameL" Name="Option2" Margin="10,0,0,0"/>
        </StackPanel>

        <!-- New Label and Radio Buttons -->
        <Label Content="Is this an [INSERT ALT IMPORT TYPE]:" Margin="5"/>
        <StackPanel Orientation="Horizontal" Margin="5">
            <RadioButton Content="No" Name="PracticeOption1" IsChecked="True" />
            <RadioButton Content="Yes" Name="PracticeOption2" Margin="10,0,0,0"/>
        </StackPanel>
        <Button Content="OK" Name="OKButton" Margin="5" HorizontalAlignment="Right" Width="50"/>
    </StackPanel>
</Window>
"@

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $XAMLInput)
$window = [Windows.Markup.XamlReader]::Load($reader)

$OKButton = $window.FindName("OKButton")
$InputTextBox = $window.FindName("InputTextBox")
$UsernameStyleOption1 = $window.FindName("Option1")
$UsernameStyleOption2 = $window.FindName("Option2")
$PracticeOption1 = $window.FindName("PracticeOption1")
$PracticeOption2 = $window.FindName("PracticeOption2")

# Add context menu item for "Paste"
$contextMenu = New-Object Windows.Controls.ContextMenu
$menuItemPaste = New-Object Windows.Controls.MenuItem
$menuItemPaste.Header = "Paste"
$menuItemPaste.Add_Click({
    $InputTextBox.Text = [Windows.Clipboard]::GetText()
})
$contextMenu.Items.Add($menuItemPaste)
$InputTextBox.ContextMenu = $contextMenu

$OKButton.Add_Click({
    $template = $InputTextBox.Text
    $usernamestyle = if ($UsernameStyleOption1.IsChecked) { 1 } else { 2 }
    $practiceOption = if ($PracticeOption1.IsChecked) {1} else {2}

    # Extract the data
    $remoteAccess = if ($template -match "Remote") { 'Y' } else { 'N' }
    $templateLines = $template -split "`r`n"
    
    # Initialize variables
    $jobTitle = $null
    $displayName = $null
    $email = $null
    $jobTitleExtracted = $false
    $displayNameExtracted = $false
    $emailExtracted = $false

    for ($i = 0; $i -lt $templateLines.Length; $i++) {
        $line = $templateLines[$i].Trim()

        if ($line -match "Select Staff Role::") {
            if ($line -match "Select Staff Role:: Other") {
                $newLine = $templateLines[$i + 1]
                $jobTitle = ($newLine -split ":", 2)[1].Trim()
                $jobTitleExtracted = $true
            } else {
                $jobTitle = ($line -split "::", 2)[1].Trim()
                $jobTitleExtracted = $true
            }
        } elseif ($line -match "New Staff Member's \(First and Last\) Name::") {
            $displayName = ($line -split "::", 2)[1].Trim()
            $displayNameExtracted = $true
        } elseif ($line -match "If the user is getting email, what should the user's email address be\?:") {
            $email = ($line -split ":", 2)[1].Trim()
            $emailExtracted = $true
        }

        if ($jobTitleExtracted -and $displayNameExtracted -and $emailExtracted) {
            # All necessary values have been extracted, exit the loop
            break
            }
    }

    # Create a password
    $password = Get-RandomPassword 8 1 5 1 1

    # Extract first name and last name
    $firstName, $lastName = $displayName -split ' ', 2

    # Create username
    if ($usernamestyle -eq 1) {
        $username = $firstname + "." + $lastName
    } elseif ($usernamestyle -eq 2) {
        $firstLetterLastName = $lastName.Substring(0, 1).ToUpper()
        $username = "$firstName$firstLetterLastName"
    }

    # Check username length
    if ($username.Length -gt 20) {
    [System.Windows.MessageBox]::Show("Username is longer than 20 characters. Please shorten the Users Lastname", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    return
    }

    $User = [PSCustomObject]@{
        username = $username
        firstName = $firstName
        lastName = $lastName
        displayName = $displayName
        jobTitle = $jobTitle
        email = $email
        remoteAccess = $remoteAccess
        password = $password
    }

    Show-ConfirmationWindow -User $User -practiceOption $practiceOption
})

$window.ShowDialog()

# --- END SCRIPT ---