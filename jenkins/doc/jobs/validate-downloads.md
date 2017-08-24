# validate-downloads

This job validates that the downloads on nodejs.org are good. 
It is scheduled to be run nightly and can also be run manually
after a release is made.  **Note:** there is delay between
when releases are generated and when they will be available on
nodejs.org(up to 15 minutes) so releasers may have to wait
a bit be able to complete the validation.

It has the following build parameters:

* `StreamAndVersion`: This can either be one of `latest`, `release`, `vX`,
  or a fully qualified version (ex v8.4.0).  If you select `release` then the
  latest release for all of the active LTS releases and the Current release
  will be validated.  If you select `release` then the
  latest release for all of the active LTS releases, the Current release
  as well as the nightlies will be validated.
  If you select 'vX' where X is is for a stream (ex v8, v7, v4) then the
  latest release from that stream will be validated.
  If you select a fully qualified version (ex v8.4.0) then that specific
  release will be validated.
* `DownloadLocation`: This controls whether the release or nightly download
  location is used. For example f you want to validate the latest v8 nightly
  you would set StreamAndVersion to 'v8' and DownloadLocation to 'nightly'.

If validation fails an email notification is sent to the
`download-validation-alert` email alias.  If you would like to get these
notifications submit a PR to have your email added for that alias in
https://github.com/nodejs/email/blob/master/iojs.org/aliases.json.

