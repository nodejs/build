# Node.js Foundation Build WG Meeting 2015-08-25

## Links

* **Meeting video:** http://www.youtube.com/watch?v=lgDa-r9F37s
* **Meeting minutes:** https://docs.google.com/document/d/1GYPt7igqna-lL1_LWs4xHCp0Gik-p-z2nOyaPdu-rtA
* **Previous meetings:** https://docs.google.com/document/d/1Kz0f0tFnt-0ahba_u-mr1w_5-8-DMzNjyiAN7a1eG3s

## Present

* Will Blankenship
* Rod Vagg
* Johan Bergström
* Alexis Campailla

## Standup

*

## Previous meeting review

*

## Minutes

### Docker testing via Jenkins

* Will presented a request from the Docker WG about getting resources for
  testing images. Using https://github.com/wblankenship/dante via Jenkins. We
  discussed repurposing an existing machine since this would be bursty work,
  focused mainly around releases. debian8 machine on Rackspace being an ideal
  candidate for now.
* TODO: make a new user account add Docker and add account to docker user group,
  fire up a new Jenkins slave for that and let Will manage that in a new Jenkins
  job.

### v4 / convergence status update

* Rod shared a status update on convergence resources: we have `*.nodejs.org`
  and `*.iojs.org` ssl certificates now, they are in the secrets repo. We are
  waiting on digicert to issue a Microsoft Authenticode certificate but that is
  paid for by the foundation. Apple has just verified a new foundation account
  so we can get a certificate out of them for OSX packages now. Rod will share
  these in the secrets repo as they become available.
* New nodejs.org server is provisioned, Rod is just working on the ansible
  scripting to make it operate similar to how we have iojs.org working.
  Unfortunately our ansible setup for iojs.org is quite out of sync with how the
  server currently works so there’s some work involved in getting that set up.
* Still talking to CloudFlare about CDN for nodejs.org, working with Mikeal and
  Terin Stock from CloudFlare on that. If we go with them they will handle DNS
  for nodejs.org too so they can serve the apex domain. This should be OK
  because they even have an API so they are not too far off from where we would
  be with Route53.

### Open items (needs cleaning)

* We need additional hardware for ARM testing; this will preferably be donated
  but if no other option is available we will look into purchasing additional
  hardware with foundation.
* Alexis will look into if we can make the linker part of windows builds faster.
