cp /etc/security/login.cfg /etc/security/login.cfg.old
awk '\
  {if ($1 == "shells") \
      if (index($0, "/bin/bash")==0) \
      { \
        gsub(/shells = /, "shells = /bin/bash,", $0); \
        print $0; \
      } \
      else print $0; \
    else print $0} \
 ' /etc/security/login.cfg > /etc/security/login.cfg.new
rm /etc/security/login.cfg
mv /etc/security/login.cfg.new /etc/security/login.cfg
