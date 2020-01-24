# Node.js build WG onboarding

This document is an outline of the things we tell new Build WG members at their
onboarding session.

## Onboarding checklists

### Onboarding to build-test issue checklist

- [ ] Email the new member and obtain their public GPG key
- [ ] Add them to the `test` group in `nodejs-private/secrets`
- [ ] Add them to the `nodejs/build` and `nodejs-private/build` GitHub teams
- [ ] Schedule a meeting with the member to:
    - [ ] Walk them through the infrastructure and what other members do 
    - [ ] Explain how to decrypt nodejs/secrets 
    - [ ] Practice running the `jenkins/worker/create.yml` playbook
  on one of the machines in the test CI cluster
    - [ ] Answer any questions they may have
- [ ] Before the meeting the Onboardee is to:
  - [ ] Install Ruby and the `dotgpg` gem
  - [ ] Install Python and Ansible
  - [ ] Read `services.md`. `jenkins-guide.md`,
    `GOVERNANCE.md` and to try and have any questions ready
- [ ] PR changes to [README.md](./README.md#build-wg-members) to add the member to build-test


All members that are onboarded to the build-release and build-infra teams
should already be a member of build-test so the checklist is shorter

### Onboarding to build-release issue checklist

- [ ] Email the new member and obtain their public GPG key
- [ ] Add them to the `release` group in `nodejs-private/secrets`


### Onboarding to build-infra issue checklist

- [ ] Email the new member and obtain their public GPG key
- [ ] Add them to the `infra` group in `nodejs-private/secrets`


[`nodejs-private/secrets` repository]: https://github.com/nodejs-private/secrets
[Node.js Foundation calendar]: https://nodejs.org/calendar
