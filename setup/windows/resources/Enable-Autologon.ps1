Param(
  [string]$UserName = $(Throw 'No user name specified'),
  [string]$Password = $(Throw 'No password specified')
)

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty $RegPath "DefaultUsername" -Value $UserName -type String
Set-ItemProperty $RegPath "DefaultPassword" -Value $Password -type String
