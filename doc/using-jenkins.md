Using the io.js Jenkins
=======================

The io.js Jenkins server can be reached at <https://jenkins-iojs.nodesource.com>. io.js core collaborators can be provided with Jenkins login credentials by the io.js Build team upon request.

The Jenkins server is used to test both the **libuv** and **io.js** projects.

The io.js Jenkins has some separate jobs and while everyone who can log in is able to start any of these jobs, users should limit themselves to just the jobs that are within their area of responsibility.

## iojs+any-pr+containers

This job can test any branch of any fork of io.js on GitHub within Linux containers. Use this job to run untrusted code if you need quick confirmation that the code is OK at least on Linux.

## iojs+any-pr+multi

This job can test any branch of any fork of io.js on GitHub across the full CI platform set. While we attempt to limit any cross-over between the test machines and the build machines, there may be some (as of writing there is some reuse of machines for ARM builds). Therefore, it is important that Jenkins users have at least basic level of confidence in the code they are submitting to run on this (and any other non-"containers") job. **Please read diffs before submitting code from untrusted users on this job.**

Currently, all slaves create _Release_ (not _Debug_) builds and run the `simple` and `message`

## iojs+npm+any-pr+multi

This job can run the `test-npm`

## iojs+release

## iojs+release+nightly

## libuv+any-pr+containers

## libuv+any-pr+multi

