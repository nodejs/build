# Node.js build WG onboarding

This document is an outline of the things we tell new Build WG members at their
onboarding session.

## Onboarding checklists

### Onboarding to build-test issue checklist

- [ ] Email the new member and obtain their public GPG key
- [ ] Add them to the `test` group in `nodejs-private/secrets`
- [ ] Add them to the `nodejs/build` and `nodejs-private/build` GitHub teams
- [ ] Before the meeting the Onboardee is to:
  - [ ] Install Ruby and the `dotgpg` gem
  - [ ] Install Python and Ansible
  - [ ] Read `jenkins-guide.md` and `GOVERNANCE.md` and have any questions ready
- [ ] Schedule a meeting with the member to:
    - [ ] Walk them through the infrastructure and what other members do
    - [ ] Explain how to decrypt nodejs/secrets 
    - [ ] Practice running the `jenkins/worker/create.yml` playbook on one of the machines in the test CI cluster
    - [ ] Answer any questions they may have
- [ ] PR changes to [README.md](./README.md#build-wg-members) to add the member to build-test


At first all members are added to nodejs/build-test. Members may be granted further permissions and access as needed
by the working group, see [GOVERNANCE](./GOVERNANCE.md).
