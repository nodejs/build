# NPM Management

We have a number of modules under the Node.js Foundation including:

* [node-report](https://github.com/nodejs/node-report)
* [node-inspect](https://github.com/nodejs/node-inspect)
* [citgm](https://github.com/nodejs/citgm)
* [llnode](https://github.com/nodejs/llnode)

We need to make sure that we have continuity in terms of being able to publish
and update these modules.

We have decided to manage these modules as follows:

* Create a user called [`nodejs-foundation`][] who we always add as one of the
  collaborators with admin rights and for which the password is maintained by
  the build workgroup.
* We would then add individuals as collaborators who can also publish.
  Generally, a module push will be done by the additional collaborators.
  The `nodejs-foundation` user is intended to be used as a backup as opposed
  to being part of the regular publishing flow.
* In the cases where collaborators other than `nodejs-foundation`
  cease to be active, the build workgroup would provide continuity by using the
  `node-foundation` user to add additional collaborators who would have the
  ability to push the module. The `node-foundation` user could also be used to
  remove collaborators if that was ever necessary.
* The purpose of the `nodejs-foundation` user is not to enable Build
  Workgroup members to publish npm modules, that should be left to the
  module collaborators.

This approach is consistent with how npm modules have been managed by a number
of the companies who are foundation members and reports are that it has worked
well.

The credentials required for the `nodejs-foundation` user are maintained in
encrypted form in the [secrets repo][].


[`nodejs-foundation`]: https://www.npmjs.com/~nodejs-foundation
[secrets repo]: https://github.com/nodejs/secrets/tree/master/test/test_credentials.md
