# Node.js Foundation Build WG Meeting 2017-10-12 22:00UTC

Next meeting: 2017-10-24 20:00UTC

## Present

- Michael Dawson
- Refael Ackermann
- George Adams
- João Reis

### When

Oct 12, 2017 10 PM UTC

### Where
- [Previous meeting](https://github.com/nodejs/build/issues/837)
- [Meeting recording](https://www.youtube.com/watch?v=miiov1RzXk8)

### Agenda

- Assert node can be compiled as static / dynamic libraries [#806](https://github.com/build/issues/806)
- tmp dir needed on ubuntu 1604 and fedora23 [#873](https://github.com/build/issues/873)

## Standup

- Refael Ackermann
  - lots of putting out fires
  - AIX machines, RAM disk was filling up and CITGM jobs were hanging, was having to
    Clean those out
 - Looking at centos situation 
- Michael Dawson (@mhdawson)
  - updating PPC machines to Java 8
  - working on getting the libuv tests running on zOS and updating the ansible scripts
- João Reis
  - Changed 4 Windows 2008 machines to VS2017 and CI to stop testing >= v9.x on VS2013.
  - Redeployed test-rackspace-win2012r2-x64-8 and updated Ansible.
  - Investigated the docs issue in DFW.

## Agenda

###Assert node can be compiled as static / dynamic libraries [#806](https://github.com/build/issues/806)

-  we discussed the best way to get a first job up and running
- Rafael, what about parametrizing
- Michael, problem is that runs will then be mixed
- Refael, maybe use pipelines
- João pipelines are expressive, but output is hard to see.
- João will clone copy of stress test (good example) and Rafeal can use that one to start as it
   already covers all platforms and has less jobs than the main build/test.

### tmp dir needed on ubuntu 1604 and fedora23 [#873](https://github.com/build/issues/873)

- Main issue was the prioritization as this seemed to hang out there a while (6 months)
- Today its takes quite a bit of pushing to get things prioritization  
- Myles had suggested project board
- Myles has also suggested paid resource from the Foundation
- João do we need to ask for more people interested in linux to join the build WG
- Refael maybe partition the farm and have owners, so that they can do these kinds of
  tasks on the general machines.
- Refael to create first draft of the board
- Refeal to reach to Chris and seishun to see if they are interested in taking some of this
- In the issue itself sounds like Rod has run job which should have created the required
  Directories.

### https://github.com/nodejs/build/pull/912

- Refael, one sentence which providers provide is ok.
- Take back to GitHub and if not resolved discuss next meeting.

## Questions

### Dropping support for 32 bit on Centos 6 [#885](https://github.com/nodejs/build/issues/885)

- Issue is that if we upgrade compiler we can no longer build 32 bit João
- Soft consensus to stop shipping 32 bit binaries and downgrade to experimental
- Next step is setting up a new machine which can be used to build for 9/master and
  existing one to be used for earlier releases. What we need is a volunteer to setup that machine
- Refael to create issue asking for machine to be created + test key added, he’ll configure, once
  ready on those with access to release infa will add there.
