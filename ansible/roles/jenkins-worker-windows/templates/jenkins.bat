:: Temurin17 can only be safely upgraded outside of the running Jenkin loop.
:: windows-update-reboot job will make sure machine is rebooted when needed.
choco upgrade Temurin17 -y
call refreshenv

C:
cd \
:start
curl -L {{ jenkins_agent_jar }} -o {{ agent_path }}
java -Dhudson.remoting.Launcher.pingIntervalSec=10 -jar {{ agent_path }} -jnlpUrl {{ jenkins_url }}/computer/{{ inventory_hostname }}/jenkins-agent.jnlp -secret {{ secret }}
echo Restarting Jenkins...
goto start
