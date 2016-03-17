# Introduction

There are a number of cases were we would like to provide access to
community machines and or jenkins jobs to people who are not part
of the build working group. Examples include:

* Test working group team members so that they can add/debug tests to/on
  community test infrastructure.
* Benchmark working group members so they can add benchmark jobs and
  or experiement with benchmarking infrastructure in advance of the
  final configuration being added to ansible.
* PR's authors so they can debug failures across platforms in cases
  where they man not personally have access to the all the different
  types of hardware.

The purpose of this document is to capture when/how such access can
be granted and any process for doing so.

## Ongoing access

In the first case we want to be able to provide ongoing access to an
individual when this supports the efforts of a working group/team. For
example some members of the test team will be regularly adding tests
and therefore the ability to create/configure tests jobs needs to be
granted in an ongoing manner.

In these cases the following will be used to decide if ongoing access
can be provided:

* Does the scope and size of the need justify providing access.
* Is the invidual a collaborator. If so then access should be allowed
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

The build team will review such requests through an issue on the repo.
Once agreed and voted upon, the individual will be granted access
through the secrets repo in a way that limits their access to the
resources required (for example test machines, or benchmarking machines).

## Temporary access

In this case temporary access to one of the test/bechmarking machines is
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
