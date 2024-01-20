# read-user-guide

**Requirements:** 
- PowerShell  
- **Users.csv** *([see resources](https://github.com/IMAG0D/Toolbox/tree/main/resources))  
- Functioning **read-user.ps1** *([see .ps1](https://github.com/IMAG0D/Toolbox/tree/main/.ps1))  
- Functioning **read-user.bat** *([see .bat](https://github.com/IMAG0D/Toolbox/tree/main/.bat))  
- New User Request (in specific format)

This script automates the New User process by letting you copy and paste the New User email in to it. It leverages off the existing Users.csv &amp; ImportUser.ps1 process

To setup all requirements, the following must be actioned/adjusted in the scripts provided to work with your env.

- **ImportUser.ps1** must ref **Users.csv** Location
- **read-user.ps1** must ref **ImportUser.ps1**
- **read-user.bat** must ref **read-user.ps1**

Example of *New User* email format:

Requestor Email Address:: requestor@email.com

Please Enter Practice Name:: Organisation name

New Staff Member's (First and Last) Name:: New Users Full Name

Select Staff Role:: Job Description

Other Role Description: Alternative Job Description

Staff member phone number:: Phone Number

What services does this User require?: Script looks for the word "remote" to add remote access

Other Services/Access:: NA

Microsoft Office Products:: NA

If the user is getting email, what should the user's email address be?: user@email.com

Email Distribution Groups:: NA

Shared Maiboxes:: NA

Completed By:: Standard SLA (within 3 Days)


1. Once all requirements are setup - run the **read-user.bat**:
2. Once Run you should get the following window:  
    [![image.png](http://wiki.tmg.health/uploads/images/gallery/2023-08/scaled-1680-/C8timage.png)](http://wiki.tmg.health/uploads/images/gallery/2023-08/C8timage.png)
3. OMITTED FOR PRIVACY REASONS
    
    - Click OK
4. After Clicking OK you will be prompted to confirm the users details: [![image.png](http://wiki.tmg.health/uploads/images/gallery/2023-08/scaled-1680-/RnDimage.png)](http://wiki.tmg.health/uploads/images/gallery/2023-08/RnDimage.png)
5. Once you click OK the following will happen:  
    \- The script will write the user details to the User.csv  
    \- The script will then run the ImportUser.ps1 script
6. Once it has attempted to create the user it will show the following:  
    [![image.png](http://wiki.tmg.health/uploads/images/gallery/2023-08/scaled-1680-/LTGimage.png)](http://wiki.tmg.health/uploads/images/gallery/2023-08/LTGimage.png)
7. DONE

