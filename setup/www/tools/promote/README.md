# io.js promote

**Scripts used on the io.js web server to promote nightly and release builds.**

* `settings` - the master settings script (for inclusion), has directory locations for each of the build types
* `_promote.sh` - the master promote script, used by `promote_nightly.sh` and `promote_release.sh`, runs the promotion process taking build files from /home/staging and putting them in /home/dist, creating shasum files and updating index files.
* `_resha.sh` - used by both `_promote.sh` and `resha_release.sh` to finalise the dist directory setup for the release/nightly being promoted, will create a shasum, run the index update process and ensure file and directory permissions are set _(Note: "resha" is probably not a good name for this)_.
* `promote_nightly.sh` a simple wrapper that feeds nightly build settings into `_promote.sh`, run via cron at regular intervals to automatically detect and promote both nightly and next-nightly builds.
* `promote_release.sh` a simple wrapper that feeds release build settings into `_promote.sh`, run via an authorised releaser for the project, generally invoked via the `dist-promote` script stored in `/usr/local/bin` which is called by [tools/release](https://github.com/iojs/io.js/blob/v1.x/tools/release.sh) on the releaser's own computer.
* `resha_release.sh` a simple wrapper that feeds release build settings into `_resha.sh`, run for stand-alone release directory shasumming by an authorised releaser for the project, invoked via the `dist-sign` script stored in `/usr/local/bin` which is called by [tools/release](https://github.com/iojs/io.js/blob/v1.x/tools/release.sh) on the releaser's own computer.
