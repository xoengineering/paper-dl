## [0.1.0]

First working version. One command for papers from any supported source, built on [dl-core](https://github.com/xoengineering/dl-core).

- Routes each paper ID or URL to the one gem that recognizes it: arxiv-dl, jstor-dl, hal-dl, ntrs-dl, or zenodo-dl.
- Input more than one source accepts, like a bare number, raises `Paper::Downloader::Ambiguous` naming the candidates. A `<source>:` prefix (`jstor:4385670`) chooses.
- Each source's papers go in their own subfolder of the root, and each source gets its own polite HTTP client.
- CLI with `--input FILE|-`, per-target error reporting, and exit status 1 on any failure, from dl-core.

## [0.0.1]

Placeholder release to reserve the name. No functionality yet.
