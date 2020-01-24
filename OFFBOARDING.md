# Node.js build WG offboarding

This document serves as a checklist of what we must go through when offboarding a member of the working group.


### Offboarding issue checklist

- [ ] Remove their GPG key from `test` group in `nodejs-private/secrets`
- [ ] Remove their GPG key from `release` group in `nodejs-private/secrets` (if applicable)
- [ ] Remove their GPG key from `infra` group in `nodejs-private/secrets` (if applicable)
- [ ] Remove them from build teams they are a member of:
    - [ ] nodejs/build
    - [ ] nodejs/build-release
    - [ ] nodejs/build-infra
    - [ ] nodejs/jenkins-admins
    - [ ] nodejs/jenkins-release-admins
- [ ] PR changes to [README.md](./README.md#build-wg-members) to move the member to emeritus status
- [ ] Remove them from the [`nodejs/email`](https://github.com/nodejs/email) alias if they are there
