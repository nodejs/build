# Introduction

There are a number of cases where we would like working group members
to be able to run and or edit jobs within jenkins. Examples include
the CITGM jobs and the Benchmarking jobs.

By default jobs can only be edited by members of the
[@nodejs/jenkins-admins](https://github.com/orgs/nodejs/teams/jenkins-admins)
group which contains a subset of the build
working group members. We do not give access to
everybody to run/edit as it would be a potential security issue,
both through the potential disclosure of secrets used as
part of the builds, as well as a potential denial
of service if jobs are launched maliciously.

This document outlines the processes by which we will allow
people outside the build working group to edit jobs as well
as allowing people who are not collaborators to run specific jobs.

Unfortunately jenkins does not allow us to easily delegate the
creation of new jobs in an appropriate manner.
As such, the creation of a new job will
need to be requested through an issue in the build repo. Any
build member can then create a blank job in the group for the
working group which can then be edited by those with access
to the jobs for that working group. As and when more jobs are
needed, a build member can clone one of the working group's 
existing jobs, which will preserve the right permissions.

## Ability to run/cancel jobs

All members of a working group will be able to run and cancel
the jobs tied to their working group. This will be accomplished
by enabling project-based security for the jobs, and then
giving the jenkins group, corresponding to the github
team for the working group, Build/Cancel permissions.

## Ability to modify jobs

A subset of the members of a working group will be able to modify
and delete jobs.  This will be accomplished
by enabling project-based security for the jobs, and then
giving the jenkins group, corresponding to the github
team for the working group admins,
the Build/Cancel/Discover/Read/Delete/Update permissions.

Since the ability to modify jobs opens up new attack vectors,
we ask that the working group limits this access to those
individuals that require it, and when appropriate, the length
of time access is granted. In addition, since build resources
are finate we also ask that the working group members are
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
issue on the working groups repo.

Once approved by the working group and existing working group admins,
one of the existing working group admins can then add the new
individual to the github admin team for the working group
(e.g. benchmarking-admins).

