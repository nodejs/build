# Overview of release process and infrastructure for Node.js

This is an overview of infrastructure owned/managed by the Build WG and how it interacts with Node.js' [release process][].

Clicking on most labels will take you to the relevant area of the build repository or other repository owned by the Node.js organization.

```mermaid
flowchart TD
    subgraph releaser[Releaser]
      start([<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md'>Start</a>])
      prepareRelease[\<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Prepare the release</a>/]
      startTestBuilds[\<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#7-ensure-that-the-release-branch-is-stable'>Start test builds</a>/]
      readyToRelease{Ready for release?}
      
      startReleaseBuilds[\<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#9-produce-release-builds'>Start release build</a>/]
      promote[\<a href='https://github.com/nodejs/node/blob/main/tools/release.sh'>Promote</a>/]
      blog[\<a href='https://github.com/nodejs/nodejs.org/blob/main/apps/site/scripts/release-post/index.mjs'>Create blog post</a>/]
      done([End])

      start-->prepareRelease-->startTestBuilds-->readyToRelease
      readyToRelease-->|No|prepareRelease
      readyToRelease-->|Yes|startReleaseBuilds-->promote-->blog-->done
    end
    subgraph github[GitHub]
      ghCode[(<a href='https://github.com/nodejs/node'>nodejs/node</a>)]
      ghWebsite[(<a href='https://github.com/nodejs/nodejs.org'>nodejs/nodejs.org</a>)]
      ghCFWorker[(<a href='https://github.com/nodejs/release-cloudflare-worker'>nodejs/release-cloudflare-worker</a>)]
      
      %% This invisible link is to aid the layout of the flowchart, stacking the repositories vertically
      ghCode ~~~ ghWebsite ~~~ ghCFWorker
    end
    subgraph buildInfra[Build WG Infrastructure]
    subgraph ci[Test CI]
      testBuilds(<a href='https://ci.nodejs.org/job/node-test-pull-request/'>Test builds</a>)
    end
    subgraph ci-release[Release CI]
      releaseBuilds(<a href='https://ci-release.nodejs.org/job/iojs+release/'>Release builds</a>)
    end
    subgraph wwwServer[<a href='https://github.com/nodejs/build/tree/main/ansible/www-standalone'>www server</a>]
      staging[(staging)]
      dist[(dist)]
      subgraph promotion[<a href='https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote'>Promotion</a>]
        subgraph nightlyPromoteCron[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tasks/site-setup.yaml'>nightly promote cron</a>]
          promoteNightly[[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tools/promote/promote_nightly.sh'>Promote nightly</a>]]
        end
        promoteRelease(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tools/promote/promote_release.sh'>Promote release</a>)
        promoteCommon(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tools/promote/_promote.sh'>Promote</a>)
        resha(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tools/promote/_resha.sh'>_resha</a>)
        uploadToCloudflare(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tools/promote/upload_to_cloudflare.sh'>upload_to_cloudflare.sh</a>)
        rebuildIdx(<a href='https://github.com/nodejs/nodejs-dist-indexer'>Rebuild index</a>)
        queueCDN[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/queue-cdn-purge.sh'>Queue CDN purge</a>]
      end
      
      subgraph nightlyCron[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tasks/tools.yaml'>nightly cron</a>]
        nightlyBuilder[[<a href='https://github.com/nodejs/nodejs-nightly-builder'>nodejs-nightly-builder</a>]]
      end

      staging-->promoteCommon-->dist
      promoteNightly-.->promoteCommon
      promoteRelease-->promoteCommon
      promoteCommon-->resha-->rebuildIdx
      promoteCommon-->uploadToCloudflare
      nightlyBuilder-.->releaseBuilds
      rebuildIdx-->queueCDN
      rebuildIdx-->dist

      subgraph cdn[<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/tasks/site-setup.yaml'>CDN purge queue</a>]
        purgeQueued{<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge queued?</a>}
        purge(<a href='https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2'>CDN purge</a>)

        purgeQueued-->|No|purgeQueued
        purgeQueued-->|Yes|purge
      end
    end
    subgraph unencrypted[www failover server]
      unencryptedRsync[[rsyncmirror.service]]
      unencryptedDist[(dist mirror)]

      dist-->unencryptedRsync
      unencryptedRsync-->unencryptedDist
    end
    end
    prepareRelease-->|Open/update pull request|ghCode
    startTestBuilds-->testBuilds
    startReleaseBuilds-->releaseBuilds
    ghCode-->testBuilds
    ghCode-->releaseBuilds
    ghWebsite-->|Pull request merged|Vercel
    promote-->promoteRelease
    blog-->|Open pull request|ghWebsite
    releaseBuilds-->|upload via <a href='https://github.com/nodejs/node/blob/main/Makefile'>Makefile</a>/<a href='https://github.com/nodejs/node/blob/main/vcbuild.bat'>vcbuild.bat</a>|staging
    staging-->|upload via <a href='https://github.com/nodejs/node/blob/main/Makefile'>Makefile</a>/<a href='https://github.com/nodejs/node/blob/main/vcbuild.bat'>vcbuild.bat</a>|r2Staging
    subgraph vercel[Vercel]
      Vercel[(Vercel)]
    end
    subgraph cloudflare[Cloudflare]
      website[[<a href='https://nodejs.org/'>https://nodejs.org/</a>]]
      cloudflareCDN[(CDN)]
      cloudflareWorker[[Worker]]
      r2Staging[(R2 Staging)]
      r2Dist[(R2 Production)]
    end
    purge-->cloudflareCDN
    dist-.->|old route/failover|cloudflareCDN
    unencryptedDist-.->|old route/failover|cloudflareCDN
    r2Staging-->uploadToCloudflare-->r2Dist
    rebuildIdx-->r2Staging
    ghCFWorker-->cloudflareWorker
    r2Dist-->cloudflareWorker
    Vercel-->|non-downloads/API docs|website
    cloudflareWorker-->cloudflareCDN-->|downloads/API docs|website

    %% Invisible links to aid the layout of the flowchart, vertically stacking some subgraphs
    ci ~~~ ci-release
    releaser ~~~ github ~~~ vercel
    promotion ~~~ cdn
    r2Staging ~~~ website
```

[release process]: https://github.com/nodejs/node/blob/main/doc/contributing/releases.md
