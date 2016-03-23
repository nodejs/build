#!/usr/bin/env bash
ssh -i /root/.ssh/nodejs_build_backup benchmark@benchmark 'mysqldump --single-transaction --extended-insert=FALSE `cat /home/benchmark/creds` benchdb | xz -c' > benchmark-$(date '+%Y%m%d').sql.xz
