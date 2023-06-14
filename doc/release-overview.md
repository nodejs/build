# Overview of release process and infrastructure for Node.js

This is an overview of infrastructure owned/managed by the Build WG and how it interacts with Node.js' [release process][].

Clicking on most labels will take you to the relevant area of the build repository or other repository owned by the Node.js organization.

```mermaid
flowchart TD
    subgraph releaser[Releaser]
      start([<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md'>Start</a>])
      prepareRelease[/<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Prepare the release</a>\]
      startTestBuilds[/<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Start test builds</a>\]
      readyToRelease{Ready for release?}
      
      startReleaseBuilds[/<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#9-produce-release-builds'>Start release build</a>\]
      promote[/<a href='https://github.com/nodejs/node/blob/main/tools/release.sh'>Promote</a>\]
      blog[/<a href='https://github.com/nodejs/nodejs.org/blob/main/scripts/release-post/index.mjs'>Create blog post</a>\]
      done([End])

      start-->prepareRelease-->startTestBuilds-->readyToRelease
      readyToRelease--No-->prepareRelease
      readyToRelease--Yes-->startReleaseBuilds-->promote-->blog-->done
    end
    subgraph github[GitHub]
      ghCode[(<a href='https://github.com/nodejs/node'>nodejs/node</a>)]
      ghWebsite[(<a href='https://github.com/nodejs/nodejs.org'>nodejs/nodejs.org</a>)]
      ghUnofficial[(<a href='https://github.com/nodejs/unofficial-builds'>nodejs/unofficial-builds</a>)]
      
      %% This invisible link is to aid the layout of the flowchart, stacking the repositories vertically
      ghCode ~~~ ghWebsite ~~~ ghUnofficial
    end
    subgraph buildInfra[Infrastructure owned by Build WG]
    subgraph ci[Test CI]
      testBuilds(<a href='https://ci.nodejs.org/job/node-test-pull-request/'>Test builds</a>)
    end
    subgraph ci-release[Release CI]
      releaseBuilds(<a href='https://ci-release.nodejs.org/job/iojs+release/'>Release builds</a>)
    end
    subgraph wwwServer[<a href='https://github.com/nodejs/build/tree/main/ansible/www-standalone'>www server</a>]
      staging[(staging)]
      promotion(<a href='https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote'>Promotion</a>)
      dist[(dist)]
      rebuildIdx(<a href='https://github.com/nodejs/nodejs-dist-indexer'>Rebuild index</a>)
      rebuildWebsite(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/build-site.sh'>Rebuild website</a>)
      www[(www)]
      queueCDN[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/queue-cdn-purge.sh'>Queue CDN purge</a>]
      webhook(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/config/github-webhook.json.j2'>Webhook</a>)
      subgraph nightlyCron[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tasks/tools.yaml'>nightly cron</a>]
        nightlyBuilder[[<a href='https://github.com/nodejs/nodejs-nightly-builder'>nodejs-nightly-builder</a>]]
      end

      staging-->promotion-->dist-->rebuildIdx
      nightlyBuilder-.->releaseBuilds

      subgraph chkIndex[Check index]
        idxChanged{<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/check-build-site.sh'>Index Changed?</a>}

        idxChanged--No-->idxChanged
      end
      
      rebuildIdx-.->idxChanged
      webhook-->rebuildWebsite
      idxChanged--Yes-->rebuildWebsite
      rebuildWebsite-->www-->queueCDN-.->purgeQueued

      subgraph cdn[CDN purge queue]
        purgeQueued{<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge queued?</a>}
        purge(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge</a>)

        purgeQueued--No-->purgeQueued
        purgeQueued--Yes-->purge
      end
    end
    subgraph unofficial[<a href='https://github.com/nodejs/build/tree/main/ansible/roles/unofficial-builds'>Unofficial builds server</a>]
      subgraph unofficialPeriodicTimer[<a href='https://github.com/nodejs/build/blob/main/ansible/roles/unofficial-builds/files/nodejs-periodic.timer'>nodejs-periodic.timer</a>]
        subgraph unofficialPeriodicService[<a href='https://github.com/nodejs/build/blob/main/ansible/roles/unofficial-builds/files/nodejs-periodic.service'>nodejs-periodic.service</a>]
          unofficialPeriodicSh[[<a href='https://github.com/nodejs/unofficial-builds/blob/main/bin/periodic.sh'>periodic.sh</a>]]
          unofficialBuildIfQueued[[<a href='https://github.com/nodejs/unofficial-builds/blob/main/bin/build-if-queued.sh'>build-if-queued.sh</a>]]
        end
      end
      unofficialManualQueue[/Manually queue build\]
      unofficialQueueBuild[<a href='https://github.com/nodejs/unofficial-builds/blob/main/bin/queue-push.sh'>Queue build</a>]
      unofficialDownloads[(download)]
      unofficialWebhook[<a href='https://github.com/nodejs/build/blob/main/ansible/roles/unofficial-builds/files/unofficial-builds-deploy-webhook.service'>Webhook</a>]
      unofficialDeploy[<a href='https://github.com/nodejs/build/blob/main/ansible/roles/unofficial-builds/files/deploy-unofficial-builds.sh'>Deploy recipes]
      unofficialRecipes[(Recipe containers)]
      
      ghUnofficial-.->|Pull request merged|unofficialWebhook-->unofficialDeploy-->unofficialRecipes
      unofficialPeriodicSh-->unofficialBuildIfQueued-->unofficialDownloads
      unofficialPeriodicSh-->unofficialQueueBuild-->unofficialBuildIfQueued
      unofficialManualQueue-->unofficialQueueBuild
    end
    subgraph unencrypted[www failover server]
      unencryptedRsync[[rsyncmirror.service]]
      unencryptedDist[(dist mirror)]
      unencryptedWww[(www mirror)]

      dist-->unencryptedRsync
      www-->unencryptedRsync
      unencryptedRsync-->unencryptedDist
      unencryptedRsync-->unencryptedWww
    end
    end
    prepareRelease-->|Open/update pull request|ghCode
    startTestBuilds-->testBuilds
    startReleaseBuilds-->releaseBuilds
    ghWebsite-.->|Pull request merged|webhook
    promote-->promotion
    blog-->|Open pull request|ghWebsite
    releaseBuilds-->staging
    subgraph cloudflare[Cloudflare]
      cloudflareCDN[(CDN)]
    end
    purge-->cloudflareCDN
    dist-.->cloudflareCDN
    www-.->cloudflareCDN
    unencryptedDist-.->cloudflareCDN
    unencryptedWww-.->cloudflareCDN

    %% Invisible links to aid the layout of the flowchart, vertically stacking some subgraphs
    ci ~~~ ci-release ~~~ unofficial
    unofficial ~~~ unencrypted
    buildInfra ~~~ cloudflare
```

[release process]: https://github.com/nodejs/node/blob/main/doc/contributing/releases.md
