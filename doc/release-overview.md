# Overview of release process and infrastructure for Node.js

This is an overview of how the release process for Node.js works and how it interacts with Build WG infrastructure.
Clicking on most labels will take you to the relvevant area of the build repository or other repository owned by the Node.js organization.

```mermaid
flowchart TD
    subgraph user[Releaser]
      start([<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md'>Start</a>])
      prepareRelease(<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Prepare the release</a>)
      startTestBuilds(<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Start test builds</a>)
      readyToRelease{Ready for release?}
      
      startReleaseBuilds(<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#9-produce-release-builds'>Start release build</a>)
      promote(<a href='https://github.com/nodejs/node/blob/main/tools/release.sh'>Promote</a>)
      blog(<a href='https://github.com/nodejs/nodejs.org/blob/main/scripts/release-post/index.mjs'>Create blog post</a>)
      done([End])

      start-->prepareRelease-->startTestBuilds-->readyToRelease
      readyToRelease--No-->prepareRelease
      readyToRelease--Yes-->startReleaseBuilds-->promote-->blog-->done
    end
    subgraph github[GitHub]
      ghCode[<a href='https://github.com/nodejs/node'>nodejs/node</a>]
      ghWebsite[<a href='https://github.com/nodejs/nodejs.org'>nodejs/nodejs.org</a>]
      
      %% This invisible link is to aid the layout of the flowchart, stacking the two repositories vertically
      ghCode ~~~ ghWebsite
    end
    subgraph buildInfra[Owned by Build WG]
    subgraph ci[Test CI]
      testBuilds(<a href='https://ci.nodejs.org/job/node-test-pull-request/'>Test builds</a>)
    end
    subgraph ci-release[Release CI]
      releaseBuilds(<a href='https://ci-release.nodejs.org/job/iojs+release/'>Release builds</a>)
    end
    subgraph www[www server]
      staging[(staging)]
      promotion(<a href='https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote'>Promotion</a>)
      dist[(dist)]
      rebuildIdx(<a href='https://github.com/nodejs/nodejs-dist-indexer'>Rebuild index</a>)
      rebuildWebsite(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/build-site.sh'>Rebuild website</a>)
      queueCDN[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/queue-cdn-purge.sh'>Queue CDN purge</a>]
      webhook(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/config/github-webhook.json.j2'>Webhook</a>)

      staging-->promotion-->dist-->rebuildIdx

      subgraph chkIndex[Check index]
        idxChanged{<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/check-build-site.sh'>Index Changed?</a>}

        idxChanged--No-->idxChanged
      end
      
      rebuildIdx-.->idxChanged
      webhook-->rebuildWebsite
      idxChanged--Yes-->rebuildWebsite
      rebuildWebsite-->queueCDN-.->purgeQueued

      subgraph cdn[CDN purge queue]
        purgeQueued{<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge queued?</a>}
        purge(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge</a>)

        purgeQueued--No-->purgeQueued
        purgeQueued--Yes-->purge
      end
    end
    end
    prepareRelease-->|Open/update pull request|ghCode
    startTestBuilds-->testBuilds
    startReleaseBuilds-->releaseBuilds
    ghWebsite-.->|Pull request merged|webhook
    promote-->promotion
    blog-->|Open pull request|ghWebsite
    releaseBuilds-->staging
    purge-->cloudflare

    %% This invisible link is to aid the layout of the flowchart, stacking the "Test CI" subgraph above the "Release CI" subgraph
    ci ~~~ ci-release
```
