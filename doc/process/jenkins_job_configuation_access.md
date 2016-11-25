# Introduction

There are a number of cases were we would like working group members
to be able to run and or edit jobs within jenkins. Examples include
the CITGM jobs and the Benchmarking jobs.

By default jobs can only be edited by build working group members
and start/stopped etc. by collaborators. We do not give access to
everbody to run/edit as it would be a potential security issue,
both through the potential disclosure of secrets used as
part of the builds, as well as a potential denial
of service if jobs are launched maliciously.

This document outlines the processes by which we will allow
people outside the build working group to edit jobs as well
as allowing people who are not collaborators run specific jobs.

Unfortunately jenkins does not allow us to easily delegate the
creation of new jobs.  As such the creation of a new job will
need to be requested through an issue in the build repo.  Any
build member can then create a blank job in the group for the
working group which can then be edited by those with access
to the jobs for that working group.

## Ongoing access

In the first case we want to be able to provide ongoing access to
an individual to edit or run a job associated with a working group
when this supports the efforts of a working group/team. For
example, some members of the benchmarking team will be regularly
modifying benchmarking jobs and therefore the ability to configure
benchmarking jobs needs to be granted in an ongoing manner.

In these cases the following will be used to decide if ongoing access
can be provided:

* Does the scope and size of the need justify providing access.
* Is the invidual a collaborator? If so then access should be allowed
  provided the first point is satisfied.
* Length and consistency of involvement with Node.js working groups
  and/or community.
* Consequences to the invidudal in case of mis-bahaviour. For example,
  would they potentially lose their job if they were reported as
  mis-behaving to their employer ? Would being banned from involvement
  in the Node.js community negatively affect them personally in some other
  way ?
* Are there collaborators who work with the individual and can vouch for
  them.

The build team will review such requests through an issue on the build
repo which lists:

* individual
* collaborator status
* information supporting request as per the items listed above
* run/cancel requested: yes/no
* edit requested: yes/no
* Period requested for:  Indefinite or a specific from -> to

The request should start with 2 lgtms from working group members and
then the the build WG will review and vote on the request.

Once approved the individual will be
added to the list of people who can either

* run/cancel the job
* edit the job

The minimum required level of access needed to get the job
done should be requested.

## Temporary access

Collaborators can be given temporary access to edit jobs without
further process (They already have access to run/cancel jobs).
A simple request as an issue in the build repo from one of the
other working group members (ex CITGM or benchmarking WG), with
the period for which is being requested will be sufficient.
Any member of the build
working group can validate their collaborator status and provide
access for up to 1 month.  The issue for the request will stay
open in the repo until access is removed.

For non-collaborators, if the considerations listed for ongoing
access are satisfied, access can
be granted after discussion in a issue on the repo and 2 lgtms
from a build team member (1 working group team member raises issue
2 build working group members lgtm).  The issue will remain
open in the build repo until access is removed.

