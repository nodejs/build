# Node.js Foundation Build WG Meeting 2016-12-20

GitHub issue: https://github.com/nodejs/build/issues/574
Meeting video: https://www.youtube.com/watch?v=-93fTN8M2BE

Previous meeting: https://docs.google.com/document/d/1l3mVB1f-JCG-05V68XIrxWNlgZdzlPPd26kIqLoBk_U

Next meeting: January 10, 2017


## Present

- Johan Bergström
- João Reis
- Myles Borins

## Standup

  - João Reis:
    - Working with Microsoft to get chakracore nightlies released (two weeks of nightlies available)

  - Johan Bergström:
    - Change backup host
    - Node.js downtime last week
    - Minor work on refactor
    - Tap2junit
    - Debian7 init script woes
    - Fix ci reporting issues to github bot

  - Myles Borins:
    - Citgm is growing as a group (5 people working on it)
    - Citgm parallelization
    - Engaged in discussion for node.js installer: https://github.com/nodejs/version-management
    - New debugger/repl talks
      https://github.com/nodejs/node/pull/10187

## Agenda

  - file and directory names for downloads #515
    - No change since last meeting; push forward


  - Draft text for HSTS communication #484
    - Johan will work on finalizing this until next meeting


  - TAP Plugin issues on Jenkins #453
    - Johan will work on finalizing this until next meeting


  - rsync endpoint to mirror the releases #55
    - Look at adding ssl to unencrypted.nodejs.org if it needs to be a mirror
    - Try to accelerate development shielding all downloads with cloudflare


  - Looking for issue good for first contribution #495

# Other issues/topics

  - Where do we post the postmortem from last outage? Perhaps two versions.
