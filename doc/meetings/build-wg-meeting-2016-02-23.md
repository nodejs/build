# Node.js Foundation Build WG Meeting 2016-02-23

## Links

GitHub issue: https://github.com/nodejs/build/issues/336
Meeting video: http://www.youtube.com/watch?v=I_RHZVFPwMU
Meeting minutes: https://docs.google.com/document/d/1srGblqnYaC5k-lHCSy08ar4aiq02lV2zWPA4vtzp5KQ
Previous meetings: https://docs.google.com/document/d/1hP5CmYFc8OkEk83gdnEo3J7W5nhDpVBKSL2uGso0ta0

## Present

* Alexis Campailla (@orangemocha)
* Joao Reis (@joaocgreis)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Rod Vagg (@rvagg)

## Standup

Skipped

## Minutes

### Jenkins access \[#331]

* Some discussion on what levels of access we should provide and to who.
  * collaborators
  * build/test teams
  * release team

* Possible actions
  * agreed that we should work towards completely separate jenkins infra/slaves
    for release
  * agreed to add checkbox on test jobs to confirm that they have reviewed the
    PR being tested for security attacks.

* Discussion on separate jenkins for test experimentation (with reduced set of
  slaves). Will learn from creation of jenkins for release and then see if it
  makes sense for test experimentation
* Will offer test team machine/mentoring to explore if they can set up their
  own instance.

### Setup to publish benchmark results to nodejs.org \[#281]

Michael: what needs to be happening: rsync and pull from github repo

Rod: I’ll take it on. Will ping the right people for public review.

### Backups for our resources \[#308]

Rod: what's the status here, what can we do to move forward or is it done?

Johan: Have done most of the work. Will run daily, weekly, monthly incremental
rsync. Will have backups for 1 year. Releases saved forever.

Johan: Held off on this work after the last Jenkins security advisory.
