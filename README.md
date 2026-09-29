# paper-dl

Download papers for offline archives, from any supported source, with one command.

`paper-dl` routes each paper ID or URL to the `<site>-dl` gem that handles it:

| Source | Gem | Example input |
| ------ | --- | ------------- |
| arxiv.org | [arxiv-dl](https://github.com/xoengineering/arxiv-dl) | `2508.16190`, `https://arxiv.org/abs/2508.16190` |
| JSTOR Early Journal Content, via the Internet Archive | [jstor-dl](https://github.com/xoengineering/jstor-dl) | `10.2307/4385670`, `https://www.jstor.org/stable/4385670` |
| HAL, France's national open archive | [hal-dl](https://github.com/xoengineering/hal-dl) | `hal-01207234v1`, `https://hal.science/hal-01207234` |
| NASA Technical Reports Server | [ntrs-dl](https://github.com/xoengineering/ntrs-dl) | `https://ntrs.nasa.gov/citations/19700020471` |
| Zenodo publications | [zenodo-dl](https://github.com/xoengineering/zenodo-dl) | `10.5281/zenodo.884117`, `https://zenodo.org/records/884117` |

Each gem's README covers what it saves, its layout, and its source's terms. Read those before archiving from a source, especially [ntrs-dl's](https://github.com/xoengineering/ntrs-dl#nasas-terms-read-before-using).

## Installation

```sh
gem install paper-dl
```

This installs every `<site>-dl` gem above too.

## CLI usage

```sh
paper-dl <PAPER_ID_OR_URL> [<PAPER_ID_OR_URL>...]
```

Papers from different sources can be mixed in one run.

### Ambiguous input

Some input fits more than one source. A bare number could be a JSTOR stable ID or a Zenodo record ID, and an 11-digit number could also be an NTRS ID. `paper-dl` doesn't guess. It reports the candidates:

```txt
4385670: 4385670 could be jstor or zenodo. Prefix it to choose, like jstor:4385670
```

Prefix the input with a source name to choose: `jstor:4385670`, `zenodo:884117`, `ntrs:19700020471`, `hal:hal-01207234`, `arxiv:2508.16190`. URLs and DOIs are never ambiguous.

### Flags

| Flag                      | Description                                                                   |
| ------------------------- | ----------------------------------------------------------------------------- |
| `-i FILE`, `--input FILE` | Read IDs/URLs from FILE, one per line (`-` for stdin, blanks and `#` skipped) |
| `-p PATH`, `--path PATH`  | Root download directory                                                       |
| `--rate-limit SECONDS`    | Seconds between HTTP requests to each source (`0` disables throttling)        |
| `-v`, `--verbose`         | Print step lines and per-request URL/byte logs to stdout                      |
| `-q`, `--quiet`           | Print nothing to stdout. Errors still go to stderr.                           |
| `--version`               | Print the gem version and exit                                                |
| `-h`, `--help`            | Print help and exit                                                           |

`-v` and `-q` are mutually exclusive.

### Environment variables

| Variable              | Effect                                                      |
| --------------------- | ----------------------------------------------------------- |
| `PAPER_DOWNLOAD_PATH` | Root download directory (default: `$HOME/Downloads/Papers`) |
| `PAPER_RATE_LIMIT`    | Seconds between HTTP requests (default: `3`, `0` disables)  |

Precedence: CLI flag, then ENV var, then default.

### Errors and exit status

A target that fails (unrecognized, ambiguous, not found, not available, HTTP error, network failure) is reported on stderr as `<target>: <message>`, and the remaining targets still download. Exit status is `0` when every target succeeds and `1` when any fails.

## Output layout

Each source's papers go in their own subfolder of the root, laid out as that source's gem lays them out:

```txt
$PAPER_DOWNLOAD_PATH/                   # default: $HOME/Downloads/Papers
  arxiv/YYYY/MM/DD/<category>/<id>-<slug>/
  hal/YYYY/MM/DD/<domain>/<hal-id>-<slug>/
  jstor/YYYY/MM/DD/<journal>/<jstor-id>-<slug>/
  ntrs/YYYY/MM/DD/<subject>/<ntrs-id>-<slug>/
  zenodo/YYYY/MM/DD/<type>/<concept-id>-<slug>/
```

Each source gets its own polite HTTP client, with that gem's User-Agent and its own rate limit, since each is a different server.

## Library usage

```ruby
require 'paper/downloader'

route = Paper::Downloader::Router.new.route 'https://www.jstor.org/stable/4385670'
route.source.name # => "jstor"
route.identifier  # => a Jstor::Downloader::Identifier
```

## Development

```sh
script/setup    # install dependencies
script/test     # run specs and rubocop
script/console  # interactive prompt
```

## License

MIT. See [LICENSE.md](LICENSE.md).

## Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/3/0/) 3.0. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
