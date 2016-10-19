# Node.js Foundation Build WG Meeting 2016-10-11

GitHub issue: https://github.com/nodejs/build/issues/512

Meeting video:https://www.youtube.com/watch?v=nbYrQ43cpf4 (partial as internet
dropped for participant who started recording and we could not restart)

Previous meeting: https://docs.google.com/document/d/1mz-gvvFlaZaz1Fdl_fM5oLGtOHMRugul4XjkR537UnM/edit

Next meeting: November 1, 2016


## Present

* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* João Reis (@joaocgreis)
* Rich Trott (@Trott)
* Michele Capra (listening in)
* Gibson Fahnestock (@gibfahn)
* Myles Borins (@TheAlphaNerd) 

## Standup

* João Reis
  * Created a job to test ChakraCore (PR under review in 
    node-chakracore to mark failing tests as skip).
  * Dropped support for VS2013 in v6 onwards.
* Michael Dawson 
  * Fixed up issue on AIX machine related to building.
    from private repo.
  * Finished off migration to new PPC production machines
  * Starting back on the job for coverage.
* Johan Bergström 
  * Fixing issues with freeBSD hosts.  May be related to issues
    related to V8 5.4 upgrade. In addition ansible config in repo was missing
    some updates so on re-deploy there were some issues.
  * Added freeBSD 11.
  * Reshuffling of hosts, more diversity over Rackspace, Digital
    ocean and Joyent.
  * Re-keyed all of the machines and wrote ansible script to automate
    re-key. It will be included as part of the larger ansible refactor.
  * Continued work on ansible refactor.
* Rich Trott
  * Working on occasional test failure.
* Gibson Fahnestock
  * Looking at some AIX issues. Python not finding right ssl
    certificates which was seem for 4.x builds that need to download
    ICU.
* Myles Borins
  * Not too much in the last few weeks.
  * CITGM changes to (re-)add windows support.

## Agenda

* Draft text for HSTS communication #484
  * call for everybody to review/comment
  * some discussion that we should check tools (ex nvm), Myles and Rich 
    to add the tools that we should check out to the issue.
* TAP Plugin issues on Jenkins #453
  * Myles provided an update on the issue.  Need to make new
    reporter that will do appropriate conversion.
  * Johan is going to look at the reporter.
  * Myles is looking at the consumer.
* rsync endpoint to mirror the releases #55
  * just depends on communication, please review comment or wil
    move forward.
* Access to AIX machines to provide coverage #470
  * now that Gibson is a collaborator, Michael proposed we just give
    him access to the test keys. Please review issue and LGTM or
    raise objections.
  * Discussion was that he should just be added to the build WG.  We.ll open an 
    issue for that and then vote next meeting.
* Looking for issue good for first contribution #495
  * Key issue is what kinds of things can be done without elevated access.
  * Johan has a few ideas:
    * improve ansible doc/tooling to make it more effective.
    * link between the build/node repo, ex Alpine.  Become the champion
      of a specific platform.
   * links to other working groups like github bot.  If we can move more
     out of jenkins into bots.
* Sounds like Michele is going to work  on windows ansible scripts:
  * helping to add windows to refactor Johan is working on.
  * optimizing how we do certain things on windows.  
* Discussion about our jenkins use and looking at how to optimize as being 
  another good stand alone task.

