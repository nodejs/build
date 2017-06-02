# Node.js Foundation Build WG Meeting 2017-05-30
 
* [GitHub issue](https://github.com/nodejs/build/issues/737)
* [Meeting video](https://www.youtube.com/watch?v=5WV7TjUww-w)
 
Next meeting: 20 June 2017
 
## Present
* Michael Dawson (@mhdawson)
* JoãReis (@joaocgreis)
* Gibson Fahnestock (@gibfahn)
* Rod Vagg (@rvagg)
* Michele Capra (@piccoloaiutante)
* Kunal Pathak (@kunalspathak)
* Kyle Farnung (@kfarnung)
* Ali Iyaz Sheikh (@ofrobots)
* Johan Bergström (@jbergstroem)
 
## Standup
* Michael Dawson
  * Starting on ansible scripts for zOS
  * Reaching out to mac provider
  * Working to get more benchmarking team participants
    working with benchmarking CI jobs
* João Reis 
  * Addedd Ubuntu and OSX to Node-ChakraCore test job
  * Changed the Node-ChakraCore nightlies release server to
   Ubuntu 14.04, opened PR with Ansible changes
  * Added VS2017 to the CI test matrix
  * Fixed rebasing in the CitGM job
  * Working on a new job to replace node-stress-single-test
* Gibson Fahnestock 
  * Minor Jenkins fixes (skipping platforms etc)
  * Refactored CitGM builds to fix AIX issue
* Michele Capra
  * Testing ansible refactor on windows
* Johan Bergström 
  * merging ansible refactor
  * minor review
  * going to update clang version of our freebsd builders to address v8 build issues
*Kyle/Kunal
  * trying to get chakracore builds working for ubuntu 14
* Rod Vagg
  * brought up 2 new centos 6 build machines, attached to ci release
  * set jenkins to choose those nodes if building node 8 and above
  * centos chosen for earlier version but not node 8
 
## Minutes
 
### Add Michele Capra (@piccoloaiutante) to the Build WG [#711](https://github.com/nodejs/build/issues/711)
 * No objections. Welcome Michele.
 
### Make regular canary builds with V8 lkgr [#626](https://github.com/nodejs/build/issues/626)
* Any objections? No.
* Need suggestion for naming in nodejs.org/download.  @ofrobots joined,
  so asked him for suggestion.  Suggested v8canary. @rvagg volunteered to
  do updates required to add.  A bit more complicated due to the new naming in
  the download structure.  So might take a bit longer.
 
### New meeting time for build WG [#98](https://github.com/nodejs/build/issues/698)
 
* We agreed to alternate between 20 and 22 UTC going forward.  Next meeting
  will be at 20 UTC.
* Michael to contact William to get calendar updated.
 
### Mac support in the cloud  [#724](https://github.com/nodejs/build/issues/724)
* want to move section on donors to to nodejs.org website.  
* maybe even shared image but whatever is the best way ?
  -> open an issue in the nodejs.org (Gibson to create)
* Node.js infrastructure sponsor logo/language, 
* Official twitter account on an internal , Michael to talk to
  Tracy to see what we can do on these 2 fronts.
* Node Interactive, mention sponsors in talks
* Rod: We should do blog posts on things the build WG are
  doing, and we could mention the sponsors in there.
* Rod created https://github.com/nodejs/build/issues/741 to collect ideas
    
### downloads/cloudflare
* Call to action to help get cloudflare coverage
* Main work is to capture metrics from cloudflare logs versus our logs,
  Rod: half done if anybody can help out that would be great.
  Rod, to create an issue.
 
### Solution to vendors to rsync securely [#55](https://github.com/nodejs/build/issues/55)
* @ofrobots a better/more secure solution for downloads ?
* Rodd: We.ve looked at it but no great answers.  
* Johan any suggestions ?
* Ali: if there was a json page we could just directly parse it
  without worrying about nginx updates breaking html parsing
 
## Questions
* no questions.
