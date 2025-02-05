# MacStadium Orka VPN setup for Jenkins


The following steps will guide you through setting up a VPN connection to the MacStadium Orka environment for Jenkins.

This process is done manually, but it can be automated in the future.

Currently our Orka cluster is hosted in the MacStadium datacenter. The VPN connection is required to access the Orka environment from the Jenkins server using the plugin [Orka by MacStadium](https://plugins.jenkins.io/macstadium-orka/).


---

**IMPORTANT**

Before you start, you need to have a clear understanding of the networking setup in the Jenkins server and the VPN connection. If you are not familiar with these topics, please ask for help from the Build team.

You can collect information about current setup and the changes that the VPN performs by running the following commands:

```bash
ip addr
ip route
cat /etc/resolv.conf
sudo iptables -L -n -v
```

---

## Steps

1. You need to ssh to the Jenkins server and install the OpenVPN client. You can do this by running the following commands:

```bash
sudo apt-get update
sudo apt-get install openconnect
```

2. In the secrets repo you can find the information needed to connect to the VPN and also the content for the connection script file.

3. Create a new file in the Jenkins server with the content from the secrets repo. 

```bash
touch /root/orka-vpn-connect.sh
nano /root/orka-vpn-connect.sh
chmod +x /root/orka-vpn-connect.sh
```

4. Execute the script to connect to the VPN and ensure that is working correctly.

```bash
./root/orka-vpn-connect.sh
```

5. You need to add firewall rules to allow the Jenkins server to access the Orka environment. You can do this by running the following commands:

```bash
# Check the current firewall rules
sudo iptables -L -n -v 
# Add the new rules
sudo iptables -A INPUT -s 10.221.190.0/24 -j ACCEPT -m comment --comment "Orka MacOS VPN"
# Check the new rules
sudo iptables -L -n -v
```


5. In a new terminal using ssh, you can check the VPN connection by running the following command:

```bash
curl <ORKA_ENDOPINT>
```

If you got an html response, the VPN connection is working correctly. If you got an error, please ask for help from the Build team.

6. Stop the script running in the other terminal, so your VPN connection is closed.

7. Now we will create a systemd service to start the VPN connection when the Jenkins server boots, that will also ensure the connection is re-established if it is lost.

```bash
touch /etc/systemd/system/orka-vpn.service
```

8. Add the following content to the file `nano /etc/systemd/system/orka-vpn.service`:

```
[Unit]
Description=OpenConnect VPN for Orka
After=network.target

[Service]
Type=simple
ExecStart=/root/orka-vpn-connect.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

8. Enable the service and start it.

```bash
sudo systemctl enable orka-vpn
sudo systemctl start orka-vpn
```

9. Check the status of the service.

```bash
sudo systemctl status orka-vpn
```

10. Check the VPN connection by running the following command:

```bash
curl <ORKA_ENDOPINT>
```