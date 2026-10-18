# nodejs-dist-mirror

Keeps a local mirror of <https://nodejs.org/dist/> up to date. It replaces the
rsync endpoint on `unencrypted.nodejs.org`, which is being retired
([#3960](https://github.com/nodejs/build/issues/3960),
[#4085](https://github.com/nodejs/build/issues/4085)).

It is a thin wrapper around [rclone](https://rclone.org/)'s
[HTTP backend](https://rclone.org/http/). It reads the same public directory
listings and files anyone can download, over HTTPS, through Cloudflare's cache.
No credentials are needed.

## Requirements

- bash
- [rclone](https://rclone.org/downloads/) (tested with 1.75)
- [jq](https://jqlang.org/) 1.6 or newer

## Usage

```sh
# Incremental: new releases, releases from the last RECENT_DAYS days, and
# the top-level index files. Cheap enough to run hourly.
./nodejs-dist-mirror.sh /srv/mirror/nodejs-release

# Full: a complete `rclone sync`, which also picks up changes to older
# releases and deletes files removed upstream. Run it weekly.
./nodejs-dist-mirror.sh --full /srv/mirror/nodejs-release

# Extra rclone flags go after `--`, for example to limit bandwidth:
./nodejs-dist-mirror.sh /srv/mirror/nodejs-release -- --bwlimit 20M
```

Environment variables:

| Variable      | Default                    | Meaning                                         |
| ------------- | -------------------------- | ----------------------------------------------- |
| `DIST_URL`    | `https://nodejs.org/dist/` | Upstream to mirror.                             |
| `RECENT_DAYS` | `14`                       | Incremental runs re-check releases this recent. |

The script does no locking. Run it from a scheduler that never starts two runs
against the same directory at once (tunasync, a systemd timer, or
`flock -n /run/nodejs-dist-mirror.lock ./nodejs-dist-mirror.sh ...` in cron).

For the first run, use `--full`, or the incremental mode, which fetches every
release directory that is missing locally.

## How it handles symlinks

The `dist/` tree on the old server had symlinks such as `latest/`,
`latest-v22.x/` and `latest-jod/`. Over HTTP these look like ordinary
directories, and copying them would duplicate tens of GB.

The script therefore skips them during the transfer. Afterwards it recreates
them as real local symlinks, computed from `index.json`, and swaps each one in
atomically. The rules match the release worker's
[`latestVersions.json`](https://github.com/nodejs/release-cloudflare-worker/blob/main/src/constants/latestVersions.json):

- `latest` points to the newest release.
- `latest-vN.x` points to the newest `vN` release. In the v0 era only
  `latest-v0.10.x` and `latest-v0.12.x` exist.
- `latest-<codename>` points to the newest release of each LTS line.
- `node-latest.tar.gz` points to `latest/node-<version>.tar.gz`.

Those are the only symlinks that get special treatment. Upstream has about 70
more file-level aliases from the v0.x era, such as
`v0.3.3/node-v0.3.3.tar.gz -> ../node-v0.3.3.tar.gz` and
`v0.8.8/node-v0.8.8-x64.msi -> x64/node-v0.8.8-x64.msi`. They never change,
so they are mirrored as ordinary files, which costs a few hundred MB of
duplicates.

## Ordering

Incremental runs copy release directories before the top-level `index.json`
and `index.tab`. Clients such as `nvm`, `n`, `fnm` and `volta` read those
indexes, so they never see a version listed whose files are not there yet.

## Load on nodejs.org

The script identifies itself with the User-Agent
`nodejs-dist-mirror (+https://github.com/nodejs/build)`. Please don't remove it.
It lets us tell mirror traffic apart from other traffic, and reach out before
throttling anything.

Each file is checked with a HEAD request, which Cloudflare's cache answers.
On an up-to-date mirror, an incremental run that finds nothing new takes about
2 seconds. A `--full` run lists every directory and checks every file, which
takes about a minute. Please run `--full` no more than once a day.
