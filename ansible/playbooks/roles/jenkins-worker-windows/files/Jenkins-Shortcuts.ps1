$WshShell = New-Object -comObject WScript.Shell

$DesktopLnk = "$env:USERPROFILE\Desktop\Jenkins.lnk"
$StartupLnk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Jenkins.lnk"

$Shortcut = $WshShell.CreateShortcut($DesktopLnk)
$Shortcut.Arguments = "/c C:\jenkins.bat"
$Shortcut.Description = "Runs the Jenkins slave"
$Shortcut.IconLocation = "C:\jenkins.ico,0"
$Shortcut.TargetPath = "%windir%\system32\cmd.exe"
$Shortcut.WorkingDirectory = "C:\"
$Shortcut.Save()

copy $DesktopLnk $StartupLnk

$ShellApp = new-object -com "Shell.Application"
$DesktopLnkFolder = $ShellApp.Namespace((Split-Path $DesktopLnk))
$DesktopLnkItem = $DesktopLnkFolder.Parsename((Split-Path $DesktopLnk -leaf))
$DesktopLnkItem.invokeverb('taskbarpin')
