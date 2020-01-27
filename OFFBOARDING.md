# Node.js build WG offboarding

This document serves as a checklist of what we must go through when offboarding a member of the working group.


### Offboarding issue checklist

(Remove items if not applicable)

- [ ] Remove their GPG key from `test` group in `nodejs-private/secrets`
- [ ] Remove their GPG key from `release` group in `nodejs-private/secrets`
- [ ] Remove their GPG key from `infra` group in `nodejs-private/secrets`
- [ ] Remove their GPG key from `infra-macstadium` group in `nodejs-private/secrets`
- [ ] Remove their GPG key from `github-bot` group in `nodejs-private/secrets`
- [ ] Remove them from build teams they are a member of:
    - [ ] nodejs/build
    - [ ] nodejs/build-release
    - [ ] nodejs/build-infra
    - [ ] nodejs/jenkins-admins
    - [ ] nodejs/jenkins-release-admins
    - [ ] nodejs-private/build
- [ ] PR changes to [README.md](./README.md#build-wg-members) to move the member to emeritus status
- [ ] Run `ncu team sync` to vaildate the user has been removed from the build teams
- [ ] Remove them from the [`nodejs/email`](https://github.com/nodejs/email) alias
