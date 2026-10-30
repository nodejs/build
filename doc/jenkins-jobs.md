# Jenkins Jobs

## [validate-downloads](https://ci.nodejs.org/view/All/job/validate-downloads/)

This job validates that the downloads on nodejs.org are good. It is scheduled to
be run nightly and can also be run manually after a release is made. **Note:**
there is delay between when releases are generated and when they will be
available on nodejs.org (up to 60 minutes) so releasers may have to wait a bit
be able to complete the validation.

If validation fails an email notification is sent to the
`release-validation-alert` email alias. If you would like to get these
notifications submit a PR to have your email added for that alias in
https://github.com/nodejs/email/blob/HEAD/iojs.org/aliases.json.

This job needs to be updated each time a we roll over to a new Current
release.

## notarize-darwin-tarballs (ci-release, to be created)

Nightly job on ci-release that checks the darwin tarballs of the supported
release lines for an Apple notarization ticket and submits the ones that lack
it, see [nodejs/node#67140](https://github.com/nodejs/node/issues/67140). It
has to run on a macOS release node (full Xcode and the `NODE_RELEASE_PROFILE`
keychain profile), so it cannot live on the test CI.

Freestyle job restricted to a `macos*-release-*` label, checking out
`nodejs/build`, with the `SSH_RELEASE_*` credential binding from
`iojs+release` and `NOTARIZATION_TEAM_ID` set to the Node.js team id,
running the same keychain unlock `iojs+release` uses (the notary credentials
are read from the keychain profile, so `NOTARIZATION_PASSWORD` is not
needed):

```shell
security unlock-keychain -p "$SSH_RELEASE_PASSWORD"
tools/macos-tarball-notarization.sh --submit --all-supported --latest 3
```

Each check downloads a tarball, so only the three most recent releases per
line are covered nightly; older ones are a manual run with a larger
`--latest`. Supported lines come from the Release schedule, so the job needs
no editing on roll-over. Submissions are serial: each waits for Apple's
verdict (bounded to 30 minutes by `notarytool --timeout`) and then up to
eight minutes for the ticket to become visible, so 18 binaries can take over
11 hours if Apple is slow on every one. Disable concurrent builds and give the
first run a 16 hour timeout, or run it by hand in two or three batches with
explicit versions. A rerun skips every binary that already has a ticket and
resubmits the rest, so a run that hits the timeout is simply rerun. One hour
is enough once everything is ticketed. A rejected submission prints
Apple's notary log in the build output.

The ticket check queries Apple's ticket service by code directory hash, the
same lookup macOS performs; a failed lookup is reported as such and never
counted as a missing ticket. Exit 1 means a completed check found a published tarball whose
`bin/node` has no ticket, or an invalid signature: in the nightly `--submit` run that
should not happen and points at a tarball axis of `iojs+release` that
stopped notarizing. Exit 3 means a check or a submission could not complete:
download, extraction, a rejected or timed-out notarytool submission, or a
binary not signed by the expected team; read the build output for which.
Notify `release-validation-alert` on both, as for `validate-downloads`.
