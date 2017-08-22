# Node.js Foundation Build WG Meeting 2017-08-22

Next meeting: 12 September 2017

### When

Aug 22, 2017 8 PM UTC


### Where

- [Youtube stream, for viewers](https://www.youtube.com/watch?v=WF7oa1heAko)
- [Previous meeting](https://github.com/nodejs/build/issues/819)


## Present
* Michael Dawson (@mhdawson)
* João Reis (@joaocgreis)
* Gibson Fahnestock (@gibfahn)
* Rod Vagg (@rvagg)
* Refael Ackermann (@refack)


## Standup

* Michael Dawson (@mhdawson)
  * Working on emails (thanks Rod)
  * Working job for download testing
  * Helped refack with n-api
  * Getting libuv job running on z/OS machines
  * Want to get back on Mac configuration
* João Reis (@joaocgreis)
  * Updated Git in Windows machines
  * Changed some Jenkins jobs to run in `jenkins-workspace`
* Gibson Fahnestock (@gibfahn)
  * Access.md
  * Helping teams with CI jobs
* Rod Vagg (@rvagg)
  * Jenkins workspace rearrangement (new machines)
  * Keeping various machines up and running properly
  * Cluster maintenance (ARM), reimaging and replacing SD cards
  * Brought 2 ODroids back online, (2 Xus are still offline and we only have
    1 handling remaining work
  * PR for miscellaneous info
* Refael Ackermann (@refack)
  * Onboarded
  * Initiated work on an napi-addon job
  * Talking with libuv about a smoke test job

### Agenda

Extracted from `wg-agenda` [issues](https://github.com/nodejs/build/issues?q=is%3Aopen+is%3Aissue+label%3Awg-agenda) and [pull requests](https://github.com/nodejs/build/pulls?q=is%3Aopen+label%3Awg-agenda+is%3Apr) from this repo.

* Create subteams to document release/infra/github-bot access [#826](
  https://github.com/nodejs/build/issues/826)
* Demo KeyBox at next WG Meeting [#806](
  https://github.com/nodejs/build/issues/806)
* tools: add download testing [#804](
  https://github.com/nodejs/build/pull/804)
* Migrate job configuration to pipeline files [#838](
  https://github.com/nodejs/build/issues/838)



## Minutes

### Create subteams to document release/infra/github-bot access [#826](https://github.com/nodejs/build/issues/826)

- Gibson: worried about things getting out of sync
- Michael: Github teams are private though
- Gibson: Yeah, not the best solution
- Rod: How about we put it in the Readme
- Refael: Or maybe the wiki, it’s easier to update
- Gibson: So giving someone access usually involves an issue or a request, so we
  could make that request a PR.
- All: Sounds good
- Action: Gibson to PR changes to Readme.
- João: I think there’s already one for github-bot, so that should be fine.

### Demo KeyBox at next WG Meeting [#806](https://github.com/nodejs/build/issues/806)

- Gibson: We should probably postpone
- Rod: Sure, but worried that if it misses a few meetings it’ll get lost
- Michael: We could have a separate meeting
- Gibson: Maybe same time one of the other weeks
- Rod: How about we wait till next time, and then if it’s missed next week we
  can arrange a special meeting.
- All: Sounds good.

### tools: add download testing [#804](https://github.com/nodejs/build/pull/804)

- Gibson: Mostly wanted to discuss where this stuff should go.
- Rod: I really like this method (clone build repo, run script)
- Gibson: That’s what we’re doing internally and it works really well.
- Gibson: So maybe put in in `jenkins/` to prepare for other Jenkins scripts?
- All: sounds good
- Rod: What else might go in there.
- Gibson: That ties neatly into the next topic

### Migrate job configuration to pipeline files [#838](https://github.com/nodejs/build/issues/838)

- Gibson: Would be good to get stuff out of the config.xml Jenkins files and
  into Github
- Michael: Could you quickly cover the benefits of pipelines
- Gibson: Basically write your config as a Groovy file, rather than as options
  in the GUI. It should also allow a lot more flexibility.
- Michael: Would it allow us to condense our scripts more (fewer pipelines than
  jobs, e.g. the “npm test a module” jobs)
- Gibson: Yes, it should do that.
- Rod: I really like the idea in principle, but in practice I’ve found pipelines
  a pain, and not particularly flexible, they seem like something bolted on
  afterwards. We don’t want to get stuck with a suboptimal solution.
- All: Yep, let’s take it gradually.
- Gibson: We should try with one of the smaller WG projects, maybe the n-api CI
  job that Refael is working on.
- All: Sounds good.

### Jenkins update requiring Java 8 [#775](https://github.com/nodejs/build/issues/775)

- Rod: So at the moment we’re stuck on this version of Jenkins until we can get
  all our machines on Java 8. I’ve upgraded some but it’s hard going. This might
  also impact our ability to switch to pipelines. Is this going to be a
  permanent thing?
- Gibson: George Adams has experience with this, he updated all the
  [AdoptOpenJDK](https://github.com/AdoptOpenJDK/openjdk-infrastructure)
  machines to Java 8, and they work with a similar set of machines. I know
  George has been keen to contribute to our Build WG, so maybe some of the
  Ansible updates made there could be ported over if applicable.
- Rod: Sounds good. It’s possible pipelines are all plugin based, and don’t
  really depend on having the latest Jenkins anyway.
- Gibson: Either way we need to block out a time, or organise tasks that need
  doing, or have a hack day, to deal with this, it’s a major chunk of work.
