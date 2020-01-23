### Build Working Group

The Node.js Build Working Group maintains and controls infrastructure
used for continuous integration (CI), releases, benchmarks,
web hosting (of nodejs.org and other Node.js web properties) and more.

Our mission is to provide Node.js Foundation projects with solid computing
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
proposals to add new members. You can see existing [Build WG members][] on the
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
     working groups and activities. The longer the better.
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
WG are either here via GitHub issues or through the `#node-build` channel on
Freenode [IRC][].

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

### WG Meetings

The WG meets fortnightly on a Zoom Webinar. A designated moderator
approved by the WG runs the meeting. Each meeting should be
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

### Consensus Seeking Process

The WG follows a [Consensus Seeking][] decision-making model.

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

[Node.js Code of Conduct]: https://github.com/nodejs/TSC/blob/master/CODE_OF_CONDUCT.md
[Node.js Moderation Policy]: https://github.com/nodejs/TSC/blob/master/Moderation-Policy.md
[the onboarding doc]: /ONBOARDING.md