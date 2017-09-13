# Node.js Foundation Build WG Meeting 2017-09-12

Next meeting: 2017-10-03 20:00UTC

## Present

- Michael Dawson (@mhdawson)
- Gibson Fahnestock (@gibfahn)
- Rod Vagg (@rvagg)
- Refael Ackermann (@refack)
- George Adams (@gdams)

### When

Sep 12, 2017 10 PM UTC


### Where
- [Youtube stream, for viewers](https://www.youtube.com/watch?v=oflJCk6hne0)
- [Previous meeting](https://github.com/nodejs/build/issues/837)

### Agenda

Extracted from `wg-agenda` [issues](https://github.com/nodejs/build/issues?q=is%3Aopen+is%3Aissue+label%3Awg-agenda) and [pull requests](https://github.com/nodejs/build/pulls?q=is%3Aopen+label%3Awg-agenda+is%3Apr) from this repo.

- Demo KeyBox at next WG Meeting [#806](https://github.com/nodejs/build/issues/806)
- ansible: use gcc 4.9 on CentOS 6 [#809](https://github.com/nodejs/build/pull/809)
- ansible: use gcc 4.9 on Ubuntu 14.04 [#797](https://github.com/nodejs/build/pull/797)


## Standup

- Rod Vagg
  - Usual machine fixing work
  - Jenkins issues
  - Reprovision macOS machine
- Refael Ackermann
  - Help n-api addon job
  - Some fixups on AIX
  - Learning about pipelines
- Michael Dawson (@mhdawson)
  - Some work to keep benchmarking jobs runs running
  - Adding graphics for new donators
  - Work to get ok to get Ok for George to help on Mac install, and will do bootstrap later
     this week.
  - Continuing to work on z/OS machine setup and ansible script
- George
  - initial discussion with Michael on the Mac OS setup
  - presentation on keybox, tool used in another project
- Gibson Fahnestock
  - Maintenance on AIX machines
  - Testing/using Ansible scripts
  - Jenkins maintenance

## Agenda


### Demo KeyBox [#806](https://github.com/nodejs/build/issues/806)

- George: Keybox is a really useful key management tool we’re using in AdoptOpenJDK.
- Rod: This could really help us automate our currently manual key management.
  setup, and it would be great to use.
- Michael: What's the platform support?
  - George: Anything that can run an ssh server is fine, we've got it working on
    Windows, z/OS etc.
- Rod: Is there a backup in case this goes wrong?
- George: We have another root user that isn't managed by Keybox, so if it goes
  wrong we can still use that user to log on.
  - Gibson: Still sounds like it'd be better than our current setup.
  - Rod: Most of our machines can be reprovisioned if there's a problem.
- Gibson: Can you backup the config?
  - It has a set of config files you can just backup.
- Rod: How does it handle more complex setups, e.g. jump boxes?
  - George: It doesn't as yet, but the devs are open to improvements (and it's
    OSS).
- Rod: What about user account levels?
  - George: There are different tiers of user access.
- Michael: What's it like for initial machine setup?
  - George: Just provide IP/Port and Username/Password.
- Gibson: Where should we put this?
  - Rod: How about on one of the CI machines. Only issue is Jenkins has had many
    security vulnerabilities.
- Everyone: Think about where to install and comment in the issue.


### ansible: use gcc 4.9 on CentOS 6 [#809](https://github.com/nodejs/build/pull/809)

- Gibson: Same as the next one really.
- Rod: I thought RHEL 6 stopped supporting 32-bit installations anyway, so can
  anyone get a 32-bit version?
- Rod: I guess the point is that 4.9 might fix some compiler bugs we'll hit
  going forward, but of course it might not.
- Gibson: Do we want to keep supporting 32-bit going forward? Is anyone using
  it?
  - Rod: http://nodejs.org/metrics, looks like it's still considerable.
  - Gibson: But that might all just be CI.
  - Rod: Yeah no way of knowing.
- Gibson: Looks like the devtoolset doesn't support 32-bit.
  - Rod: But presumably you could still build 32-bit right?
  - Gibson: Not sure.
- Rod: There is a trend towards dropping 32-bit. Relates to the discussion we were having about supported platforms.
- Gibson: It'd be nice to have a way to flush out the people who are still
  relying on it.
  - Rod: If we were going to drop it might make more sense to drop on an
    odd-numbered release (gives people time to complain and we could add it
    back).
- Gibson: What about ARM, are people running 32-bit on embedded?
  - Rod: No, only old ARM. And I think we only have to consider Intel here.
- Rod: Only question is Windows, but I think we're safe there too, there's no
  32-bit support.
- Michael: If we're going to drop on an odd number, would 9 be too soon, or
  would 11 be the target?
  - Rod: I think 9 might be too soon.
  - Refael: I don't think it's too soon, it sounds like it's only people with
    old systems.
  - Michael: it doesn't give much time for discussion though.
  - Rod: We did already bump the requirements, so those old systems are already
    unsupported.
  - Refael: Yeah they'll probably stick with an old LTS.
- Gibson: Okay so we could try it for 9.0.0 and see who complains.
- Michael: How much work would it be to change this?
  - Rod: Should just be some Jenkins config work.
  - Gibson: Shouldn't be too much, Rod did something simiilar for CentOS 6.
  - Rod: We'd have to look at tests as well.
  - Michael: Might need changes for the website too.
- Gibson: We could just float it as a proposal.
- Gibson: It'd also free up more test machines.
  - Rod: Would be good to talk to someone who knows more about Windows.
- Gibson: So is this PR good to land?
  - Rod: My concern is that a devtoolset-6 binary might not work on a vanilla
    machine. I'll test it out.
- Gibson: I'll raise an issue to discuss 32-bit in 9.x.


### ansible: use gcc 4.9 on Ubuntu 14.04 [#797](https://github.com/nodejs/build/pull/797)

- Gibson: This one should be fine, we don't build releases on Ubuntu so it's not an
  issue.
  - All: No issues with this.


### Store resources for Ansible on jenkins ci master [#871](https://github.com/nodejs/build/issues/871)

- Rod: What would this be for?
  - Just things we'd need to set up machines that aren't easy to get from other
    sites.
- Rod: I'd like to put my custom-built ARM gcc on there as well.
- Rod: Could it just be a simple http static file server with NGINX?
  - Michael: Sure
- Gibson: Would we want to limit access to just CI machines?
  - Rod: I'd be fine if people were to start downloading my ARM build.
- Michael: We'd need an http fallback for machines that have issues with https?
  - Rod: Seems fine, use https where we can, but fallback to http is fine.
- Michael: Might it be a security risk?
  - Rod: I'm much more worried about the security risk that Jenkins poses.
- Rod: I can set this up today.
- Gibson: Would that be an infra account?
  - Rod: Yes, but we can always add an unpriveleged account for test if they
    need it.
- Gibson: Might it get overloaded if it's sharing a machine with Jenkins?
  - Rod: NGINX is really efficient, not worried. If it ends up on StackOverflow
    we can change it.
