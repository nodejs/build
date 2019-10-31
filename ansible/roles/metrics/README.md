* Copy secrets/build/infra/gcp-metrics-service-acct-key.json to ~nodejs/
* As user `nodejs` run `gcloud auth activate-service-account --key-file gcp-metrics-service-acct-key.json`
* Set up new SSH key with access to root@direct.nodejs.org and root@backup-www.nodejs.org under user `nodejs`
