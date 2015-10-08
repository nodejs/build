C:
cd \
:start
curl -L https://ci.nodejs.org/jnlpJars/slave.jar -o C:\slave.jar
java -Dhudson.remoting.Launcher.pingIntervalSec=10 -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/{{ server_id }}/slave-agent.jnlp -secret {{ server_secret }}
echo Restarting Jenkins...
goto start
