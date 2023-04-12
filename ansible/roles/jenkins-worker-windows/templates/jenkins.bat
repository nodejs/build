C:
cd \
:start
curl -L {{ jenkins_agent_jar }} -o {{ agent_path }}
java -Dhudson.remoting.Launcher.pingIntervalSec=10 -jar {{ agent_path }} -jnlpUrl {{ jenkins_url }}/computer/{{ inventory_hostname }}/jenkins-agent.jnlp -secret {{ secret }}
echo Restarting Jenkins...
goto start
