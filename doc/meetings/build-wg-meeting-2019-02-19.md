# Node.js Foundation Build WorkGroup Meeting 2019-02-19

## Links

* **Recording**: https://www.youtube.com/watch?v=6u0tl-BWajo
* **GitHub Issue**: https://github.com/nodejs/build/issues/1691

## Present

* Michael Dawson (@mhdawson)
* Refael Ackermann (@refack)
* Rod Vagg (@rvagg)
* Rich Trott (Trott)

## Agenda

## Announcements
 
* MacStadium has renewed for another year. (up to Feb 28th).  A big thanks!
* New domain with website prototype supposed to go live today. Seems to be online.\

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * No update
  *  Let make the next meeting focus on Resources/Responsibilities/Permissions. (March 13)

* Use Foundation resources to support build [#1154](https://github.com/nodejs/build/issues/1154)
  * No update
  * Itemize the things that we do and what resources we are using so that we review this.  
  * Let make the next meeting focus on Resources/Responsibilities/Permissions. (March 13)

* Raspberry PI 1s
  * They are often the bottleneck and are more so as time goes on.
  * A few seem to be a recurring problem.  We have 14.  2 are reserved for release. Those
    will go away once releases are retired (possibly when 6 goes out of service)
  * We do parallelization of 6, if all online we can do 2 at the same time.  Most often take 42 mins 
    to complete.  Even with more parallelization still the overhead of file system checkout.
  * Rod, any path to coming up with a reduced test suite that might lighten the load
    setup. For debug build Rafael has exclude list that reduces coverage by only 1%
    for 15% less execution time.  For debug we only run once a day.
  * MIght be option to run full test suite twice a day and reduce what we run in the PR
    regression test.
  * Rod would be good to identify tests that never fail versus those we see fail on different
    platforms.
  * Rafael has also done some worth with BCoe to try an map coverage back to the tests and
    then focus the testing for a given PR.
  * Rod issue also applies to releases so not just for PRs. If we don’t make a decision for 12.x
    locking costs in for 3 years.
  * Rod, tweet or whatever to ask for input on dropping 6.x.  Rafael maybe also talk to 
    Raspberry PI foundation as they are interested in Node.js a good runtime for it.
  * Rafael has heard to Debian would like to drop support for Arm 6.  But Raspbian still is 
    compiled for Arm v6.
  * Rafael will try to connect to the Raspberry PI Foundation.
  
* Python 3 support
  * Rafael progressing, next step is likely to start installing Python 3 on more machines.

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.


