# Node.js Foundation Build WG Meeting 2016-04-26

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/397
* **Meeting video:** http://www.youtube.com/watch?v=O4mGTvbd4gQ
* **Meeting minutes:** https://docs.google.com/document/d/1ZVKuahiMFgXU66t7xuv4DWLPyRTPrDVzlcd9tgSQT4I
* **Previous meeting:** https://docs.google.com/document/d/1kwN7aNBrF257yxBaSYtQyerxXZnfmu7hOjdJiAFKqbo

## Present

* Alexis Campailla (@orangemocha)
* Hans Kristian Flaatten (@starefossen)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Rich Trott (@Trott)

## Standup

* Alexis Campailla
  * Running citgm on Windows. Figuring out how to add support in CI

* Joao Reis (absent)
  * I made two changes to the ARM cross compilation and binary test jobs: fixed
    cross compilation for ICU and testing armv7 binaries on the Pi2 and Pi3.

* Michael Dawson
  * adding linuxOne machines
  * ppc be machines moved over ubuntu
  * v8 testing in Node tree, initial set of platforms complete
  * new libuv test jobs

* Hans Kristian Flaatten
  * not much build related

* Johan Bergström
  * Refactored linting by improving parallel job running (could be extended to
    Make build in the future)
  * Removed pub-key from ansible - using GitHub keys instead
  * Refactored Nginx (SSL) config for nodejs.org
  * Spent some time with OS X
  * Working with the GitHub Bot Team - possible integration with Jenkins in the
    future
  * Jenkins slaves flagged as offline - must be forced reconnection

* Myles Borins
  * Speeding up canary in the gold mine (citgm) by caching
  * Platform specific features for citgm

* Rich Trott
  * not much build related

## Minutes

### Access to build resources \[#354]

Michael: taken the action to create the straw man, this is more of a reminder

Alexis: looks ok...

Johan: access through shared keys

Alexis: <concerned about how to revoke access>

Johan: build needs access for managing infrastructure, external needs access to
inspect why a given test fails

Michael: would be more restrictive by giving individual access

Alexis: do we need to delete any secrets on the slave before giving access?

Johan: no, this secret is not

Alexis: could this be used to reconnect the slave?

Johan: yes

Johan: giving untrusted access could be solved by creating a new machine. we
have scripts for automated setup.

Michael: collaborators and trusted contributors are eligible for ongoing access
if they need that. If there are not enough trust we will need to disconnect the
  slave and re-image after use.

Johan: we should have an audit log. Do we need to keep a list of people who are
allowed to delegate access?

Alexis: people who have ongoing access can give access to others

Michael: procedure for approving ongoing access is detailed in #354

### OS X buildbots/ci \[#367]

Johan: the problem is growing, we do not have enough testing on OS X. The
current platform we are testing on, Voxer, are shutting down? We might not have
OS X testing! V8 just dropped support for 10.6 and 10.7. Node.js is only testing
on 10.10. Looked into testing, ideally a company would step up donating the
proper resources, otherwise there are commercial companies offering this.

Michael: Do we know anyone in Apple?

Johan: have checked with Apple Sidney HQ, without much luck

Alexis: macstadium, what ranges of OS X does they offer? You \[Johan] estimated
$800/month?

Johan: Apple does not provide old versions of Mac OS X, macstadium gives us a
good matrix coverage.

Alexis: Looks like a good deal

Johan: We get 3x Mac minis

Alexis: what else can we do if there are no one else stepping up?

Johan: we could reach out to other teams (marketing?), really want to see an OS
X company step up. Company support would benefit the Node.js Build Working
Group.

Alexis: could we  highlight the need for Mac OS X hardware this in the build
README?

Johan: I can create an issue in the node repo for this

Alexis: do we need to testing on all six versions? Could we opt for more
redundancy?

Johan: we have not defined what we support for 0.10, 0.12, and 4. We should
support this initially before there is a decision for dropping support for older
versions.

Alexis: could we test for 10.7 and the two latest versions?

Johan: yeah, that could be a possibility. We as a build group should come up
with a recommendation

Michael: support for Mac OS X 10.6 has been dropped from v8

Myles: we just bumped the minimum Mac OS X version to 10.7 in Node.js. V8 have
dropped official support for 10.7 and 10.8.

Johan: lts is undefined. 10.5 is the lowest barrier, suggest 10.6 should be the
minimum.

Michael: IBM have only been supporting minimum 10.8. OS X in production is using
the LTS versions. Developers have can more easily use more recent versions

Alexis: suggest follow the recommendations from v8

Myles: as long as v8 is offering unofficial support for lower versions it might
be hard to drop those versions

Myles: top priority should be automated tests for 10.11, 10.10, and 10.9. There
was recently an issue related to 10.11.

Myles: open call to companies or institutions for Mac OS X hardware

Michael: do we really want hardware? We might not get the older versions

Johan: a good fit would be a company that cares for different Mac OS X versions

Michael: it needs to give us hardware with the correct versions of Mac OS X

Alexis: reach out to Mikeal to get something out on the blog

Alexis: should we suggest 10.11, 10.10, and 10.09?

Michael: we should not wait too long

Alexis: $800/month sounds reasonable

Michael: it is flexible with regards to moving resources

Michael: it is worth a last attempt to find an company that fits

Johan: bin at this for a few months

Michael: is two weeks enough?

Alexis: decide on the next meeting

Johan: preferable to find the right group or person to message the request

Myles: can pass this along to Mikeal

Alexis: can raise this as a TSC issue

Myles: Rod expressed wishes that the Mac OS X hardware should be community
supported

Johan: seconds that

Alexis: links up with Myles after he have talked with Mikeal

### Accept terms of use for linuxOne machines \[#386]

Michael: awaiting reply

Johan: have replied

Michael: checking again

### The serialport daily test run in CI

Alexis: The serialport daily test run in CI. We have recently re-enabled it. I
wanted to make sure that everyone is ok with running this as part of Node's
Jenkins or whether it belongs somewhere else.

Michael: is this like a physical machine?

Alexis: yes, as it requires a serial port device which is why we can not use a
virtual machine

Michael: is it possible to install such a device on a virtual machine?

Alexis: will share details with Michael

Alexis: any objections for making this a part of the Node’s Jenkins?

Johan: what other place could we put it? It is relevant.

Alexis: just wanted to make sure this was ok

Michael: it does not have access to Jenkins?

Alexis: no

Michael: +1 from me then

### GitHub team name for CI Working Group \[nodejs/CI#7]

Alexis: We could have a quick discussion about GitHub team names for CI.
Related: nodejs/CI#7

Alexis: currently people are mentioning @nodejs/ci for reporting issues with
Jenkins CI

Alexis: should we make a new GitHub team or use @nodejs/build?

Michael: have there been many issues of this kind?

Alexis: no, I do not think so

Michael: we can message it, we can make a new team, we could ask CI to forward
issues

Alexis: we could message this better

Alexis: what is the right @-mention?

Johan: there is a distinction between Build Group and Jenkins Admins (which have
admin access to Jenkins).

Johan: I can see that there is a distinction, but do not think it is a problem
using @nodejs/build for the time being

Michael: @nodejs/build looks like the right way

Alexis: I’ll open a PR to document this and leave the CI group name as it is for now

## Previous meeting review

\[skipped due to time constraints]

## Follow-ups
