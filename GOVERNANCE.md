### Build Working Group

The Node.js Build Working Group maintains and controls infrastructure
used for continuous integration (CI), releases, benchmarks,
web hosting (of nodejs.org and other Node.js web properties) and more.

Our mission is to provide Node.js projects with solid computing
infrastructure in order to improve the quality of the software itself by
targeting correctness, speed and compatibility and to ensure streamlined
delivery of binaries and source code to end-users.

The WG has final authority over this project and associated teams including:

* nodejs/build
* nodejs/build-release
* nodejs/build-infra
* nodejs/jenkins-admins
* nodejs/jenkins-release-admins

For the current list of WG members, see the project
[README.md](./README.md#build-wg-members).


### WG Membership

WG seats are not time-limited.  There is no fixed size of the WG.

The Build WG is comprised of individuals who are interested in managing servers
and the services that are managed on behalf of the Node.js project. Membership
is determined by the group itself, with existing, active, members voting on
proposals to add new members. You can see existing [Build WG members](./README.md#build-wg-members) on the
README.

When considering new members, the Build WG is primarily concerned with
**competence** and **trust**. Membership grants access to a significant amount
of resources. While we partition our resources into trust levels, the basic
level that all members have access to comprises the largest number of servers
maintained by the Build WG. Members should have a basic level of competence in
one or more technical areas covered by the Build WG such that the addition of
a new member spreads the maintenance burden rather than creating additional
burden because of lack of competence, or un-trustworthy behavior. The Build WG
is not an expert group and we offer a place to learn and develop skills. Members
should be aware of the bounds of their expertise and act accordingly.

* Competence: it is difficult to objectively gauge technical competence without
  demonstration. You can demonstrate competence by contributing to resources in
  this repository where you see need or attempting to assist Build WG members
  where you are able. Competence may also be demonstrated through contributions
  to other activities of the Node.js project, although competence in software
  development does not necessarily correlate with the type of technical
  competence the Build WG would prefer.
* Trust: because we are granting access to protected resources, the Build WG
  needs to establish trust. Individuals with no prior relationship to the
  Node.js project or one of its member companies are likely to be asked to
  contribute as a non-member where possible for a period of time to establish
  the basics of a trust relationship. The most two most straightforward paths
  to trust are:
  1. An established relationship with the Node.js project and its associated
     working groups and activities. The longer the better. In case of doubt,
     or if the individual is _not_ a Node.js Collaborator, contact the Node.js
     TSC.
  2. A contractual relationship (such as employment) with a member company of
     the OpenJS Foundation. Contractual relationships carry legal weight and
     provide greater likelihood of a stable trust relationship; at a minimum
     they establish strong legal accountability.

Please be aware of the fact that **the Build WG is usually invisible to the
Node.js project when things go well, but highly visible when things don't go
well**. Downtime of important resources can have a very wide impact, not just
for Node.js open source contributors but for very large sections of the Node.js
user ecosystem. Security breaches could have devastating consequences and these
all reflect on the Build WG.

If you are interested in helping out with the Build WG, please reach out to
existing members to let us know. The best means for communication with the Build
WG are either here via GitHub issues or through the `#nodejs-build` channel on
the OpenJS Foundation [Slack][].

Membership is granted by way of a pull request adding a new individual to the
members list on the README (e.g. [#524][]). New members can open such a pull
request themselves, but it would be advisable to check with an existing member
before doing so. Alternatively, an existing member may "sponsor" a new member by
opening a pull request. Existing, active members will vote on a pull request and
where no objections are present after a reasonable period of time, membership
will be granted.

Depending on the level of trust and competence assessed by existing Build WG
members, new members may not be given immediate access to protected resources.
This is at the discretion of the Build WG. We ask that you not take offence if
we appear slow to grant access to resources you ask for as we take our
responsibilities regarding security and the stability of our infrastructure very
seriously.

We expect that even if you are given access to Test servers, Build Working Group
members should:

1. Not operate too far beyond their competence level without assistance.
   Humility is the key. Hubris gets you, and us, in trouble.
2. Operate in a collaborative manner _as much as possible_. The more
   communication the better and team behavior is what we expect.
3. Be sensitive to the complex web of concerns that surround our infrastructure.
   This will take some getting used to, but know that there are often very good
   reasons that things may not be according to what you think is the optimal
   situation. For example: we are dealing with donated resources and we often
   have to perform careful balancing-acts to foster these relationships.


Onboarding of new members is provided once they join, see the
[the onboarding doc][] for more details.

Once a year the Build Working Group will perform an audit of its
membership and membership of the jenkins-admins and jenkins-release-admins
teams. This is to protect the sensitive build resources by ensuring that
only active members have access to these resources. During this audit any
member can volunteer their removal from the working group or teams if they
do not have the time to continue working on the project. Any emeritus
member may rejoin the working group following consensus from the current
working group.

The Build Working Group is split into 3 tiers - Build-Test, Build-Release and
Build-Infra. To see what access the 3 tiers give and what other access is available
to member of the Working Groups see [resources.md][]

### WG Meetings

The WG meets every three weeks on a Zoom Webinar, schedule is available on the [Node.js Foundation calendar].
A designated moderator approved by the WG runs the meeting. Each meeting should be
published to YouTube.

Items are added to the WG agenda that are considered contentious or
are modifications of governance, contribution policy, WG membership,
or release process.

The intention of the agenda is not to approve or review all patches;
that should happen continuously on GitHub and be handled by the larger
group of Collaborators.

Any community member or contributor can ask that something be added to
the next meeting's agenda by logging a GitHub Issue. Any Collaborator,
WG member or the moderator can add the item to the agenda by adding
the ***build-agenda*** tag to the issue.

Prior to each WG meeting the moderator will share the Agenda with
members of the WG. WG members can add any items they like to the
agenda at the beginning of each meeting. The moderator and the WG
cannot veto or remove items.

The WG may invite persons or representatives from certain projects to
participate in a non-voting capacity.

The moderator is responsible for summarizing the discussion of each
agenda item and sends it as a pull request after the meeting.

### Communication

The Build Working Group uses GitHub Issues to manage tasks. GitHub Pull Requests are used to suggest, and then land, changes.
These Pull Requests must be:
  * Keep open for at least 48 hours during the week (72 hours on the weekend)
  * Get at least one approval from another WG member
  * Use the squash merge button workflow on Github


[Slack], specifically `#nodejs-build` is important for communicating with
other Node.js project members, and how we receive many initial signals
of downtime.


### Special Access Requests

The Build Working Group can grant special access to community machines to people who are
not members of the Working Group. Examples include:

* Test working group team members so that they can add/debug tests to/on
  community test infrastructure.
* Benchmark working group members so they can add benchmark jobs and
  or experiment with benchmarking infrastructure in advance of the
  final configuration being added to ansible.
* PR's authors so they can debug failures across platforms in cases
  where they man not personally have access to the all the different
  types of hardware.

Special access is split into two categories - Ongoing and Temporary.

#### Ongoing access

In the first case we want to be able to provide ongoing access to an
individual when this supports the efforts of a working group/team. For
example some members of the test team will be regularly adding tests
and therefore the ability to create/configure tests jobs needs to be
granted in an ongoing manner.

In these cases the following will be used to decide if ongoing access
can be provided:

* Does the scope and size of the need justify providing access.
* Is the individual a collaborator. If so then access should be allowed
  provided the first point is satisfied.
* Length and consistency of involvement with Node.js working groups
  and/or community.
* Consequences to the individual in case of misbehaviour. For example,
  would they potentially lose their job if they were reported as
  mis-behaving to their employer ? Would being banned from involvement
  in the Node.js community negatively affect them personally in some other
  way ?
* Are there collaborators who work with the individual and can vouch for
  them.

The build team will review such requests through an issue on the repo.
Once agreed and voted upon, the individual will be granted access
through the secrets repo in a way that limits their access to the
resources required (for example test machines, or benchmarking machines).

#### Temporary access

In this case temporary access to one of the test/benchmarking machines is
needed to investigate a specific issue.

Collaborators can be given access without further process using a
temporary account on the specific machines.

If the considerations listed for ongoing access are satisfied, access can
be granted after discussion in a issue on the repo after one additional
lgtm from a build team member (1 build team member raises issue, second
approves)

In cases that warrant it, access can be granted to a machine where
the individual does not meet the requirements for ongoing access, however
in this case the machine should first be disconnected from the
build farm, any secrets/credentials deleted from the machine, and the
length of access should be limited to the minimum
feasible and and the machine should be re-imaged once access has been
revoked.

Access should be recorded in a way that we can periodically review
and ensure we clean up temporary accounts that are no longer needed.
Initially this will be done by updating the readme of the secrets
repo.



#### Jenkins Job Configuration Access

There are a number of cases where we would like working group members
to be able to run and or edit jobs within Jenkins. Examples include
the CITGM jobs and the Benchmarking jobs.

By default jobs can only be edited by members of the
[@nodejs/jenkins-admins](https://github.com/orgs/nodejs/teams/jenkins-admins)
group which contains a subset of the build
working group members. We do not give access to
everybody to run/edit as it would be a potential security issue,
both through the potential disclosure of secrets used as
part of the builds, as well as a potential denial
of service if jobs are launched maliciously.

This section outlines the processes by which we will allow
people outside the build working group to edit jobs as well
as allowing people who are not collaborators to run specific jobs.

Unfortunately Jenkins does not allow us to easily delegate the
creation of new jobs in an appropriate manner.
As such, the creation of a new job will
need to be requested through an issue in the build repo. Any
build member can then create a blank job in the group for the
working group which can then be edited by those with access
to the jobs for that working group. As and when more jobs are
needed, a build member can clone one of the working group's
existing jobs, which will preserve the right permissions.

* Ability to run/cancel jobs

All members of a working group will be able to run and cancel
the jobs tied to their working group. This is accomplished
by enabling project-based security for the jobs, and then
giving the Jenkins group, corresponding to the Github
team for the working group, Build/Cancel permissions.

* Ability to modify jobs

A subset of the members of a working group are able to modify
and delete jobs.  This is accomplished
by enabling project-based security for the jobs, and then
giving the Jenkins group, corresponding to the Github
team for the working group admins,
the Build/Cancel/Discover/Read/Delete/Update permissions.

Since the ability to modify jobs opens up new attack vectors,
we ask that the working groups limit this access to those
individuals that require it, and when appropriate, the length
of time access is granted. In addition, since build resources
are finite we also ask that the working group members are
mindful of the number of long-running jobs that they start.
In particular, spawning long-running jobs on arm and windows
can easily pile up.

In the case of granting access to edit jobs the following
should be considered:

* Does the scope and size of the need justify providing access.
* Is the individual a Node.js collaborator? If so then access should
  be allowed provided the first point is satisfied.
* Length and consistency of involvement with Node.js working groups
  and/or community.
* Consequences to the individual in case of mis-behaviour. For example,
  would they potentially lose their job if they were reported as
  mis-behaving to their employer? Would being banned from involvement
  in the Node.js community negatively affect them personally
  in some other way?
* Are there collaborators who work with the individual and can vouch
  for them.

It is suggested that this consideration be documented in an
issue on the working group's repo.

Once approved by the working group and existing working group admins,
one of the existing working group admins can then add the new
individual to the Github admin team for the working group
(e.g. benchmarking-admins).

### Consensus Seeking Process

The WG follows a Consensus Seeking decision-making model.

When an agenda item has appeared to reach a consensus the moderator
will ask "Does anyone object?" as a final call for dissent from the
consensus.

If an agenda item cannot reach a consensus a WG member can call for
either a closing vote or a vote to table the issue to the next
meeting. The call for a vote must be seconded by a majority of the WG
or else the discussion will continue. Simple majority wins.

Note that changes to WG membership require unanimous consensus.  See
"WG Membership" above.

### Moderation Policy

The [Node.js Moderation Policy] applies to this WG.

### Code of Conduct

The [Node.js Code of Conduct][] applies to this WG.

[Node.js Code of Conduct]: https://github.com/nodejs/TSC/blob/HEAD/CODE_OF_CONDUCT.md
[Node.js Moderation Policy]: https://github.com/nodejs/TSC/blob/HEAD/Moderation-Policy.md
[Node.js Foundation calendar]: https://nodejs.org/calendar
[the onboarding doc]: /ONBOARDING.md
[Slack]: https://openjs-foundation.slack.com/archives/C03BJP63CH0
[#524]: https://github.com/nodejs/build/pull/524
[resources.md]: /doc/resources.md
