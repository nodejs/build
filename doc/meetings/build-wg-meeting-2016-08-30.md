# Node.js Foundation Build WG Meeting 2016-08-30

* GitHub issue: https://github.com/nodejs/build/issues/474
* Meeting video: http://www.youtube.com/watch?v=p6viQ2HyGqk 

## Present

* Hans Kristian Flaatten
* JoãReis
* Johan Bergströ Michael Dawson
* Rod Vagg
* Phillip Jonsen
* Myles Borins
* Gibson Fahnestock

## Agenda

Extracted from wg-agenda issues and pull requests from build repo:

* How can a project qualify for access to the build infrastructure? #448
* OS X buildbots/ci: call to action #367
* rsync endpoint to mirror the releases #55
* Add docs required by TSC nodejs/github-bot#66
* Process for determining supported platforms nodejs/node#8265
* TAP Plugin issues on Jenkins #453

## Standup

* Hans Kristian Flaatten (I can go first for once ;)
  * been given a formal onboarding by Johan :tada:
  * started working on Ansible playbook for Alpine Linux
  * looked into adding offline reasons to Jenkins alerts
    * .Ping timeout., .Low disk space. etc.
  * looked into moving Jenkins Monitor to Node.s infra
    * currently on a personal DO droplet & Sendgrid account 
* JoãReis
  * Wave of windows failures
  * Release machines with VS2015
* Johan Bergströ * redeployed f24 instance to run v8 tests
  * onboarded @phillipj and @starefossen
  * landed outline of onboarding documentation
  * new ubuntu16 slave and minor fixes to playbook
  * alpine34 work with @starefossen
  * fix linux nightlies build (broke two months ago)
  * ppc machine juggling/redeploying with @mhdawson
  * node-test-commitmsg work with evan lucas
  * gh-bot and jenkins integration (show test updates in PRs)
* Michael Dawson
  * Conf/addition of new AIX machines/working through test issues
  * Conf/addition of PPC machines from new osu production cluster and
    transition of existing machines
  * Addition of linuxOne release machine, testing out etc. to 
    get it added to standard release job
  * Working on build group presentation for Node Interactive EU
  * Fixed up benchmarking jobs due to dependencies issues 
  * Some discussion on jobs for code coverage
* Rod Vagg
  * Work on the arm cluster; new machines, rewiring, etc
  * Expanding the build fleet (new rpi3s)
  * Exhausting OSX sponsorship options
* Phillip Jonsen
  * Onboarded/walking through ansible
  * PR for gh-bot vm
  * Working on documentation for using vagrant/ansible locally
* Myles Borins
  * Smoke tester for ABI breakages against CITGM
  * wip: CITGM support for Windows
* Gibson Fahnestock
  * Helping Michael with AIX
  * CITGM on Windows

## Minutes

* How can a project qualify for access to the build infrastructure? #448
  * at this point is pretty much limited to projects under the org, we
    don't have many which are asking and are not being considered for that
    so we can probably leave this on the back burner for now.
  * semi-related, node serialport might move to nodejs org, 
    nvm has also made a request.
        
* OS X buildbots/ci: call to action #367
  * giving the sponsor option one more week otherwise will move forward
    to use foundation money.
  * We already have sign off to use foundation money to get this resolved.

  
* rsync endpoint to mirror the releases #55
  * no real discussion, just needs to be completed.

* Add docs required by TSC nodejs/github-bot#66
  * discussion was around whether it should be separate work
    group under the CTC or a part of the Build WG.
  * several Build WG members (Johan, Philip, and Hans)
    chimed in and augmented for the bot being a group under Build WG.
  * William Kapke (@williamkapke) argumented for the bot to be it.s
    own working group:
> The bot's scope is very crosscutting and will extend
  beyond the reach of even the CTC. This is why I pointed
  the Governance to the TSC.

  * the net is that the bot team is welcome to join build WG and do the
    work there but its up to the members of the bot group
    (@nodejs/github-bot) to propose/agree on what 
    makes the most sense for that work.

* Process for determining supported platforms nodejs/node#8265
  * problem for node collaborator with random failures on newer platforms
  * how do we determine what platforms are officially supported
    * we have not found a good way to determine these
    * we would like to add new hardware before they are officially supported
  * can we treat experimental platforms as experimental?
    * make Jenkins treat any failures for platform X as flaky (yellow)
  * build group (Rod) will make proposal to TSC.
  

* TAP Plugin issues on Jenkins #453
  * we suspect that TAP Plugin is consuming much of the resources on Jenkins.
  * every time this runs it creates an XML file which is later
    read and parsed which consumes memory possible options:
    *  we could fix this (in Java)
    *  we could write our own converter
    *  we move to produce JUnit from our test suite
  * many other tasks depends / consumes TAP output
  * CITGM has had great success with JUnit output
    * great performance
    * easier to dig through / debug
  * Myles volunteers to take a stab at converter to generate junit from the
    existing tap files
  * Don't want to use the Node build under test to run the converter
    because if you break Node bad enough you.ll end up not getting
    any parsed output.
  * Johan says this can be done on Jenkins master by writing
    to artifacts files which are sent back to Jenkins for processing 

## Next meeting

September 20th, 8pm UTC
~

