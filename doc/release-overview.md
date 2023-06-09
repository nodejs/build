# Overview of release process and infrastructure for Node.js

This is an overview of how the release process for Node.js works and how it interacts with Build WG infrastructure.
Clicking on a box should take you to the appropriate area of the build repository or other approrpiate repository owned by the Node.js organization.

```mermaid
flowchart TD
    subgraph user[Releaser]
      start([Start])-->A(Start release build)--> promote(promote)-->blog(create blog post)-->F([End])
      click start "https://github.com/nodejs/node/blob/main/doc/contributing/releases.md"
      click A "https://github.com/nodejs/node/blob/main/doc/contributing/releases.md#9-produce-release-builds"
      click promote "https://github.com/nodejs/node/blob/main/tools/release.sh"
      click blog "https://github.com/nodejs/nodejs.org/blob/main/scripts/release-post/index.mjs"
    end
    subgraph jenkins[Release CI]
      builds
      click builds "https://ci-release.nodejs.org/job/iojs+release/"
    end
    subgraph github[GitHub]
      gh[nodejs/nodejs.org]
      click gh "https://github.com/nodejs/nodejs.org"
    end
    subgraph www[www server]
      staging[(staging)] --> promotion -->dist[(dist)]
      dist-->rebuildIdx(rebuild index)
      click rebuildIdx "https://github.com/nodejs/nodejs-dist-indexer"

      subgraph chkIndex[Check index]
        idxChanged{Index Changed?}--No-->idxChanged
      end
      
      rebuildIdx-.->idxChanged
      webhook-->rebuild
      idxChanged--Yes-->rebuild(Rebuild website)
      click idxChanged "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/check-build-site.sh"
      rebuild-->queueCDN[queue cdn purge]-.->purgeQueued
      click rebuild "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/build-site.sh"
      click queueCDN "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/queue-cdn-purge.sh"
      subgraph cdn[CDN purge queue]
        purgeQueued{CDN purge queued?}
        purgeQueued--No-->purgeQueued
        purgeQueued--Yes-->purge(cdn purge)
        click purgeQueued "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2"
        click purge "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/scripts/cdn-purge.sh.j2"
      end
    end
    A-->builds(release builds)
    gh-.->webhook
    click webhook "https://github.com/nodejs/build/blob/main/ansible/www-standalone/resources/config/github-webhook.json.j2"
    promote-->promotion
    click promotion "https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote"
    blog-->|pull request|gh
    builds-->staging
    purge-->cloudflare

```
