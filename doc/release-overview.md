# Overview of release process and infrastructure for Node.js

This is an overview of how the release process for Node.js works and how it interacts with Build WG infrastructure.
Clicking on most labels will take you to the relvevant area of the build repository or other repository owned by the Node.js organization.

```mermaid
flowchart TD
    subgraph user[Releaser]
      start([<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md'>Start</a>])
      A(<a href='https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#9-produce-release-builds'>Start release build</a>)
      promote(<a href='https://github.com/nodejs/node/blob/main/tools/release.sh'>Promote</a>)
      blog(<a href='https://github.com/nodejs/nodejs.org/blob/main/scripts/release-post/index.mjs'>Create blog post</a>)
      F([End])

      start-->A-->promote-->blog-->F
    end
    subgraph jenkins[Release CI]
      builds(<a href='https://ci-release.nodejs.org/job/iojs+release/'>Release builds</a>)
    end
    subgraph github[GitHub]
      gh[<a href='https://github.com/nodejs/nodejs.org'>nodejs/nodejs.org</a>]
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
    A-->builds
    gh-.->webhook
    promote-->promotion
    blog-->|pull request|gh
    builds-->staging
    purge-->cloudflare

```
