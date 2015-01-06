# Windows Server 2012 R2 Setup

THis setup also works for **Windows Server 2008 R2** after initial default updates applied from Windows Update.

For io.js & libuv Jenkins setup, on a fresh server:

1. Use Internet Explorer to install [Chrome](http://google.com/chrome) (while shaking fists at "Enhanced Security Configuration", who thought this was a good idea?)
1. Install Microsoft **Visual Studio** Express 2013 for Windows Desktop from http://www.visualstudio.com/downloads/download-visual-studio-vs
  - Requires a Microsoft account
  - Run wdexpress_full.exe once downloaded
  - Default install options are OK
  - Don't need to "LAUNCH"
1. Install **Python** 2.7 from https://www.python.org/downloads/
  - Latest 2.7.x MSI
  - "Install for all users"
  - C:\Python27\
  - Accept other defaults
1. Install **JRE 1.8** ("Java 8") from http://www.java.com/en/download/win8.jsp
  - Default options _except Ask toolbar_
  - Take note of install location for next step
1. Edit **`PATH` environment variable** to add Python and Java
  - Start -> type "environment" -> click "Edit the system environment variables" -> click "Environment Variables" button
  - Find `Path` under "System variables" -> "Edit"
  - Append `;C:\Python27\;C:\Program Files (x86)\Java\jre1.8.0_25\bin` (adjust Java location appropriately) to the end of the "Variable value"
  - OK, OK, OK
1. Install **Git** from http://git-scm.com/download/win
  - Default options except _"Use Git and optional Unix tools from the Windows Command Prompt"_ (they are used in tests)
1. Clone **GYP**
  - Start -> "cmd"
  - Run `git clone http://git.chromium.org/external/gyp.git c:\gyp`
1. Copy **Jenkins slave.jar**
  - Start -> "cmd"
  - Run `cd \`
  - Run `curl https://jenkins-iojs.nodesource.com/jnlpJars/slave.jar -o slave.jar`
1. Install **nssm** from http://nssm.cc/download
  - Extract nssm.exe from the *win64* directory of the ZIP file into C:\
1. Create **batch file** to launch Jenkins
  - Start -> "notepad c:\jenkins.bat" (click through to start Notepad, it'll create a new file for you)
  - Put `java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/SLAVE-ID/slave-agent.jnlp -secret SECRET` (replace SLAVE-ID and SECRET) into the file and save
1. **Set up Jenkins service**
  - Start -> "C:\nssm.exe install Jenkins" (click through)
  - Application
    - Path: `C:\jenkins.bat`
    - Startup directory: `C:\`
  - Log on
    - This account: `Administrator`
    - Password & Confirm as per login
  - I/O redirection
    - Output (stdout): `C:\jenkins_stdout.log`
    - Error (stderr): `C:\jenkins_stderr.log`
  - click "Install service"
1. **Start Jenkins service**
  - Either from Start -> "Services" -> Jenkins -> Start;
  - Or on the command prompt `net start Jenkins`



