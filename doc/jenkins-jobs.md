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
