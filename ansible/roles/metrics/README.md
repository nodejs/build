### Current Work Flow
* The logs from cloudflare come in five minute intervals (e.g 20210105/20210105T141000Z_20210105T141500Z_adbdac1f.log.gz contains every log from the period of 1410 - 1415 on 2021/01/05 UTC)
* Every time a new log file is creataed it is automatically pushed to GCP to the bucket `cloudflare-logs-nodejs`
* When a new file is uploaded to `cloudflare-logs-nodejs` this triggers a "notification". This notification then sends a message to the `cloudflare-logs` topic.
* The subscription `process-logs` listens to the `cloudflare-logs` topic, when it receives a new message it takes the message metadata and then send an authenticated HTTP request to URL of the Cloud Run instance
* The Cloud Run instance is where the processing of the data takes place - the Cloud Run instance runs a docker image of `files/process-cloudflare` and has `npm run processLogs` as its entry point. When the instance receives a HTTP request it extracts the filename and bucket name from the metadata and then downloads the file inside memory. It then parses through the data and removes any unneeded rows (Logs of people visting the webpage etc.) and keeps only the logs which reference to someone downloading a binary. These logs are then cleaned of any private information and converted to CSV format.
* This data is then uploaded to a different bucket called `processed-logs-nodejs` in the same five minute interval format of the original logs
* Upon completion the Cloud Run instance sends a 200 back to the subscription and the message is then popped off the topic (The message is "awknowledged") the indicated that the message and be read and processed and is no longer neeeded.
* If any error occurs in the processing a 500 code is sent back and the subscription will try to resend the message after a time delay.
* The Cloud Run instance has 1GiB of memory assigned to it which should be enough to handle the size of the files we see.



### Accesing the GCP from command line

* Copy secrets/build/infra/gcp-metrics-service-acct-key.json to ~nodejs/
* As user `nodejs` run `gcloud auth activate-service-account --key-file gcp-metrics-service-acct-key.json`
* Set up new SSH key with access to root@direct.nodejs.org and root@backup-www.nodejs.org under user `nodejs`
