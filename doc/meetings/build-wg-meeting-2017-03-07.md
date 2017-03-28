# Node.js Foundation Build WG Meeting 2017-03-7

* GitHub issue: https://github.com/nodejs/build/issues/640
* Meeting video: https://www.youtube.com/watch?v=8RhgJMn5R88
* Previous meeting: https://docs.google.com/document/d/1A4Uv3gYoNxZONbRe6P_h36tphQotkObq8neHIXxJhrg/edit
* Next meeting: 20 March 2017

## Present
* @mhdawson   Michael Dawson
* @joaocgreis João Reis
* @jbergstroem Johan Bergström
* @gibfahn Gibson Fahnestock

## Standup
* Michael Dawson
  * misc work helping to setup CI jobs/configuration for
    node-report/node-inspect/abi-stable-node/benchmarking
* Johan Bergström
  * incremental backups
  * get a few workers back online
  * slacking
* João Reis
  * Adding VS2017 support to node-gyp and core
  * Clean-up workspace in master for node-test-binary-windows
* Gibson Fahnestock
  * updating some CiTGM jobs to test using nightlies
  * work on node-report/node-inspect jobs
  * looked at the refactor the world PR

## Agenda

* file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)
* Draft text for HSTS communication [#484](https://github.com/nodejs/build/issues/484)
* TAP Plugin issues on Jenkins [#453](https://github.com/nodejs/build/issues/453)

## Minutes

### file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)

* No discussions have been made -- remove from agenda?

### Draft text for HSTS communication [#484](https://github.com/nodejs/build/issues/484)

* Either remove from agenda or set a date (for change) we work against!
  (Doesn't seem to be a high prio for anyone)

### TAP Plugin issues on Jenkins [#453](https://github.com/nodejs/build/issues/453)

* No progress afaik (Johan)
* Johan will try to test out a bit more fully by running on a broader set of machines. 
* Gibson will also try to use it in some of the other projects like node-report.

## other issues/topics
  * Did supported platforms PR land ?
    - No - [nodejs/node#8922](https://github.com/nodejs/node/pull/8922)
    *  not yet, lets try to make sure it lands this week or so.
  * look into rewriting jenkins host init script in systemd for
    auto-restarting after OOMs
    * create issue, and mark as good first contribution (Johan) 


