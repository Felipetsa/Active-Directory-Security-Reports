# Active-Directory-Security-Reports
# Overview
This script returns useful information (reports) from AD that can help prevent/mitigate security incidents. It can also be used periodically to audit your DCs.

# Usage

Step 1: Load the Active Directory Module</br>
To connect and query an AD group with PowerShell the Active Directory module needs to be loaded.</br></br>

The Active Directory module can be installed with the following methods:</br></br>

Having RSAT tools installed</br>
Windows Server 208 R2 and above with the AD DS or AD LDS server roles</br>
You can run the following command to see if you have it installed: Get-Module -Listavailable</br>

 Step 2: .\AD_Security_Audit_logs.ps1
 
 * You can also change the $ADGroupMember = “Domain Admins” to one of your choice.</br>

# Future Work
- Option to type a group instead of a fixed group</br>
- Refine the reports/searches</br>
- Insert date in the *.CSV file name exported</br>
- Add new reports :)</br>
