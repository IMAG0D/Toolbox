#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
# 
# .__                              __                                       
# |__| _____ ______   ____________/  |_           __ __  ______ ___________ 
# |  |/     \\____ \ /  _ \_  __ \   __\  ______ |  |  \/  ___// __ \_  __ \
# |  |  Y Y  \  |_> >  <_> )  | \/|  |   /_____/ |  |  /\___ \\  ___/|  | \/
# |__|__|_|  /   __/ \____/|__|   |__|           |____//____  >\___  >__|   
#          \/|__|                                           \/     \/       
# 
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
# 
# --- BEGIN SCRIPT ---

### **** UPDATE CUSTOMER UPN HERE ****###

$UPN = "CUSTOMERS.EMAILDOMAIN.COM"

### **********************************###


#Check UPN was changed

IF ($UPN -eq "CUSTOMERS.EMAILDOMAIN.COM")
{
	Write-Host "You didn't change the customer's email domain :)"
	Exit
}

# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Create UPN

Try{Get-ADForest | Set-ADForest -UPNSuffixes @{add=$UPN} -erroraction stop; write-host "UPN $UPN added to AD" -ForegroundColor Green}
Catch{write-host "UPN addition failed; UPN probably already exists; error message was $_" -ForegroundColor Red}

#Setup Customer Specific Variables

    $ou=(Get-ADOrganizationalUnit -Filter 'Name -like "Users"')
    $currentdomain = (Get-ADDomain)
    $fqdn = $currentdomain.Forest
    $domain = $currentdomain.NetBIOSName
    $UserGroup = $domain + " Users"
    $dc01 = (Get-ADComputer -Filter 'Name -like "*DC01"' -Properties DNShostname | select -ExpandProperty DNShostname)
    $fs01 = (Get-ADComputer -Filter 'Name -like "*FS01"' -Properties DNShostname | select -ExpandProperty DNShostname)
            if ($fs01 -eq $null) {
            write-host "FS01 does not exist. $dc01 is the file server"
            $fileserver = $dc01
            }
            else {
            write-host "FS01 is part of the deployment. $FS01 is the file server"
            $fileserver = $fs01
            }  

#Store the data from Users.csv in the $ADUsers variable
$ADUsers = Import-csv Path\To\Location\Users.csv


#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
	$homedirpath = "\\$fileserver\HDrive$\$Username"
	$Username 	= $User.username
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
    $DisplayName = $User.DisplayName
    $jobtitle   = $User.jobtitle
    $Email      = $User.Email
    $ProxyAddress1 = $User.ProxyAddress1
    $ProxyAddress2 = $User.ProxyAddress2
    $ProxyAddress3 = $User.ProxyAddress3
    $telephone  = $User.OfficePhone
    $mobile     = $User.MobilePhone
    $streetaddress = $User.address
    $city       = $User.city
    $state      = $User.state
    $zipcode    = $User.PostalCode
    $country    = $User.country
    $Password = $User.Password
    $RemoteAccess = $User.RemoteAccess
    
    #check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exists in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$UPN" `
            -Name "$DisplayName" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$DisplayName" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -MobilePhone $Mobile `
            -EmailAddress $email `
            -Title $jobtitle `
            -Description $jobtitle `
            -homedrive "H" `
            -homedirectory $homedirpath `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False `
                       
            #Create New Home Drive
            New-Item -ItemType Directory -Path $homedirpath 
             
            #Grant each user Full Control to the users home folder only 
 
            #Define the user to be added           
            $UsersAm = "$Domain\$Username" 
            #Start Define variables for the access rights
            #Define FileSystemAccessRights:identifies what type of access we are defining, whether it is Full Access, Read, Write, Modify 
 
            $FileSystemAccessRights = [System.Security.AccessControl.FileSystemRights]"FullControl" 
 
            #define InheritanceFlags:defines how the security propagates to child objects by default 
            #Very important - so that users have ability to create or delete files or folders  
            #in their folders 
 
            $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::"ContainerInherit", "ObjectInherit" 
 
            #Define PropagationFlags: specifies which access rights are inherited from the parent folder (users folder). 
 
            $PropagationFlags = [System.Security.AccessControl.PropagationFlags]::None 
 
            #Define AccessControlType:defines if the rule created below will be an 'allow' or 'Deny' rule 
 
            $AccessControl =[System.Security.AccessControl.AccessControlType]::Allow  
            #define a new access rule to apply to users folfers 
 
            $NewAccessrule = New-Object System.Security.AccessControl.FileSystemAccessRule($UsersAm, $FileSystemAccessRights, $InheritanceFlags, $PropagationFlags, $AccessControl)  
 
 
            #set acl for each user folder
            
            $currentACL = Get-ACL -path $homedirpath
            #Add this access rule to the ACL 
            $currentACL.SetAccessRule($NewAccessrule)
            #Write the changes to the user folder 
            Set-ACL -path $homedirpath -AclObject $currentACL | Out-Null
            

         
            # - Add to DOMAIN users group and Staff Group
			Add-ADGroupMember -Identity $UserGroup -Members $Username
            Add-ADGroupMember -Identity "Staff Group" -Members $Username
		
            # - Add to Remote Users if Remote Access = Y
                       
            IF ($RemoteAccess -eq "Y")
                {
                    Write-Host "Remote Access for $DisplayName is $RemoteAccess"
                    Write-Host "Granting remote access for $DisplayName"
                    Add-ADGroupMember -Identity "Remote Users" -Members $Username
                }
            Else
                {
                    Write-Host "Remote Access for $DisplayName is -NOT- Y; No Remote Access for them"
                }

            IF ($proxyAddress1 -ne "")
                {
                    Set-ADUser -Identity $Username -Add @{       
                                                            'proxyAddresses' = "SMTP:" + "$Email"
                                                         }
                    Set-ADUser -Identity $Username -Add @{       
                                                            'proxyAddresses' = "smtp:" + "$proxyAddress1"
                                                         }
                }
            IF ($proxyAddress2 -ne "")
                {
                    
                    Set-ADUser -Identity $Username -Add @{       
                                                            'proxyAddresses' = "smtp:" + "$proxyAddress2"
                                                         }
                }
            IF ($proxyAddress3 -ne "")
                {
                    
                    Set-ADUser -Identity $Username -Add @{       
                                                            'proxyAddresses' = "smtp:" + "$proxyAddress3"
                                                         }
                
                }
	}




}

# --- END SCRIPT ---