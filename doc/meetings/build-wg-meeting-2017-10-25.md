# Node.js Foundation Build WG Meeting 2017-10-25

Next meeting: 2017-11-03 21:00UTC

## Present

- Michael Dawson (@mhdawson)
- Gibson Fahnestock (@gibfahn)
- Rod Vagg (@rvagg)
- Refael Ackermann (@refack)
- Even Stensberg (@ev1stensberg)

### When

Oct 24, 2017 22:00 UTC

### Where
- [Youtube stream, for viewers](https://www.youtube.com/watch?v=c2X8R50SR0w)
- [Previous meeting](https://github.com/nodejs/build/issues/902)

### Agenda

- Have Rod walk rest of build team through Cloudflare setup [#915](https://github.com/nodejs/build/issues/915)
- suggestion: investigate a commit-queue solution [#705](https://github.com/nodejs/build/issues/705)
- tmp dir needed on ubuntu 1604 and fedora23 [#873](https://github.com/nodejs/build/issues/873)
- assert node can be compiled as static / dynamic libraries [#879](https://github.com/nodejs/build/issues/879)
- Have Rod walk rest of build team through Cloudflare setup [#915](https://github.com/nodejs/build/issues/915)
- doc: update intel text in providers list (meta: negotiating wording for donor descriptions & contributions) [#912](https://github.com/nodejs/build/issues/912)
- ansible: use gcc 4.9 on CentOS 6 [#809](https://github.com/nodejs/build/pull/809)
- Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)

### Standup

- Gibson Fahnestock (@gibfahn)
  - PRs to document some of our processes.
  - Machine maintenance.
  - Helping with Automation.
- Rod Vagg
  - Digicert for 3 years.
  - Issue with node private repo, how to give bot access and share 2FA key
    between infra people.
- Refael Ackermann (@refack)
  - Created github boards and triaged issues.
  - Death by a thousand cuts, lots of little things.
  - Reached out to some people regarding joining build.
- Michael Dawson
  - Finishing off ansible scripts for zOS.
  - Addition of ARM6 backup machine and ansible script updates for that.
  - Updating contributors page for new companies.
  - Some cleanup of code coverage data to avoid rsync problem on benchmarking
    machine.
- Even Stensberg
  - Worked on webpack and webpack cli.
  - Keen to help out with Node core automation.


## Minutes

### suggestion: investigate a commit-queue solution [#705](https://github.com/nodejs/build/issues/705)

- Refael: Inspired by chromium project, thinking that automation team is a great
  time to get involved.
- Refael: How can we help with all the prior art?
- Refael: Involve the automation team to make building easier to maintain.
- Rod: Alexis and Joao were leading the charge before
- Rod: If we’re going to do this, it has to be exclusive, so it has to work
  properly.
- Refael: Release branches should easy as they are exclusive, so good POC.
- Refael: Propose to have a clone of Jenkins.
- Gibson: Have a way to test and build pipelines
- Refael: Should do what's faster
- Rod: I’d rather use pipelines
- Gibson: +1 on pipelines for new projects.

### tmp dir needed on ubuntu 1604 and fedora23 [#873](https://github.com/nodejs/build/issues/873)

- Gibson: I think this is symptomatic of a larger issue, how many people are
  actually confident in running automation?
- Refael: Part of the problem is that you need the Jenkins secret to run the
  current Ansible scripts
- Rod: For me the biggest problem is how to prioritise the work queue, and I
  think the Github project is a good start
- Michael: Part of the problem is that we’re mid migration between ansible
  scripts
- Refael: I think it’s a combination of the two
- Rod: Prioritize what’s important and what is urgent.
- Michael : Encourage people to get involved and contributing.

### assert node can be compiled as static / dynamic libraries [#879](https://github.com/nodejs/build/issues/879)

- Michael: Two choices, single platform or working platform set
- Refael: V8 linux running nightly, but another one running daily, of which is
  breaking (V8 Linux Fedora 24
  (https://ci.nodejs.org/view/All/job/node-test-commit-v8-linux-fedora24/ )).
- Gibson: could you raise that as an issue?
- Michael: Important to separate V8 issues from build issues
- Refael: Sustain decision to just get it working

### Have Rod walk rest of build team through Cloudflare setup [#915](https://github.com/nodejs/build/issues/915)
- Rod: infra have access
- Rod: iojs is on the free plan, nodejs is on the business plan (iojs has some
  business features). We also have a Cloudflare contact 
- Rod: Security is off, don’t think we need it as we just host static pages.
  Could be changed if we need to
- Rod: We serve ssl directly from them
- Rod: Only a few sites actually go through cloudflare, others are hosted
  directly
- Rod: Quite a few that should be removed
- Michael: How hard is it to switch on and off Cloudflare?
- Rod: Press of a button and it bypasses. It’s instant.
- Rod: We have a wildcard SSL certificate. We could also just use Cloudflare’s
  own certificates, but then we’d have to proxy through them for everything
  https.
- Rod: Don’t have http strict on yet
- Rod: The only thing we turned on in “firewall” is Tor
- Rod: We do aggressive caching, and default to 4h, besides from that we use
  standard configuration.
- Rod: we need to migrate of bypassing Cloudflare’s caching, we’re basically
  always going through nodejs.org, because we used to collect logs. Really we
  want to get Always Online to work. 
- Rod: Whenever we update nodejs.org, we purge everything.
- Rod: Got IPv6 working, no complaints yet.
- Rod: Load balancing is up, and we are synced with Joyent and primarily Digital
  Ocean.
- Rod: We could turn on LB on subdomains.
- Michael: What’s your normal routine for figuring out an issue if something is
  broken?
  - Rod: Have a look at health, there’s also an API (you’d need an API key),
    then you also can query to review in detail. 
- Rod: I’ve posted some details around this for people to have a look at. (You’d
  need auth email and key)
- Rod: If stale content, purge everything. Figure out the issue as well, to
  avoid the same issue.

### doc: update intel text in providers list (meta: negotiating wording for donor descriptions & contributions) [#912](https://github.com/nodejs/build/issues/912)

- Michael: Still not sure about allowing companies to put taglines on there. I
  guess it's worthwhile if it'll make a big difference for the companies.
- Michael: What if two companies want to make the same claims?
- Gibson: I don't think that's a problem.
- Rod: That's why it's in quotes right?
- Gibson: Take back to Github?
- All: Sure.

### ansible: use gcc 4.9 on CentOS 6 [#809](https://github.com/nodejs/build/pull/809)

- Refael: Test general linux and ubuntu, 32 bits should be covered. Remember not to 
  update the release machine.
- Gibson: Okay, take back to GitHub?
- All: Sure

### Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)

- Gibson: Basically by extracting all the responsibilities and special accesses
  out into subteams, we can make it really easy for people to get involved.
- Refack: Yeah, we'll need to make sure node-private and test keys get put into
  the subteam, but +1.
- Michael: Yeah sounds like a great idea.
