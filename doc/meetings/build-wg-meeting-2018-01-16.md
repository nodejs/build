# Node.js Foundation Build WorkGroup Meeting 2018-01-16

## Links
* **Recording**:  http://youtu.be/2aCpSVPYo9o
* **GitHub Issue**: https://github.com/nodejs/build/issues/1079

## Present
Michael Dawson (@mhdawson)
Kyle Farnung (@kfarnung)
Gibson Fahnestock (@gibfahn)
Joyee Cheung (@joyeecheung)

## Agenda

## Announcements
No accouncements this week
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.
### nodejs/build

* Security: please pay careful attention to code running through CI [#1070](https://github.com/nodejs/build/issues/1070)
* CI statuses not posting [#1045](https://github.com/nodejs/build/issues/1045)
* New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Ubuntu non-LTS strategy [#967](https://github.com/nodejs/build/issues/967)
* Remove Fedora 22, 23, 24 [#962](https://github.com/nodejs/build/issues/962)
* Remove Ubuntu 12.04 [#961](https://github.com/nodejs/build/issues/961)
* Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)
* file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)

#### Security: please pay careful attention to code running through CI [#1070](https://github.com/nodejs/build/issues/1070)
* From the discussion we are not sure that the new vulnerabilities drive a new
  Need to remove machines.  We don.t necessarily have data that could be more
  easily compromised through the new attacks.
* Gibson: not sure we need to worry about the test machines, even if an attacker broke
  into them, they shouldn.t be able to access anything critical, like the release infra.
* Gibson: I think a bigger issue would be making sure the cloud providers we are using
  have all been patched to make sure other VMs on the same hosts can.t break into our machines.
* Not that we don.t want to remove the older ones.

### CI statuses not posting [#1045](https://github.com/nodejs/build/issues/1045)
* Discussion was about rackspace outtage.
* All machines are back now, remaining issue may be just to make sure emails
  go to a broader group.
* Gibson to open new issue to continue discussion and get to close.

### New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Defer until we have more people in the meeting and George to help do it.

### Ubuntu non-LTS strategy [#967](https://github.com/nodejs/build/issues/967)
* Discussed, no objections, removed agenda tag.

### Remove Fedora 22, 23, 24 [#962](https://github.com/nodejs/build/issues/962)
* Looked at issue, waiting on Rod for proposal, removed agenda tag until thats ready.

### Remove Ubuntu 12.04 [#961](https://github.com/nodejs/build/issues/961)
* Waiting on update from @rvagg, removing agenda tag until there is one.

### Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)
* If we make existing privileges (access to test machines) separate from joining WG, would
  be easier to add people.
* I think we discussed in earlier meeting and no objections
* No objections in this meeting, let.s make it so.  Gibson to raise PR that updates
  our doc to explain new approach.

### file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)
* Asked ljharb in issue if he can attend next meeting (We want at least him and @rvagg in the
  discussion)

## Q&A, Other

No questions this week.

## Upcoming Meetings
* **Node.js Foundation Calendar**: https://nodejs.org/calendar
Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

