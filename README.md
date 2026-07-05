# slitayem.github.io

Personal website and blog — a Jekyll site served via GitHub Pages at [craftatscale.dev](https://craftatscale.dev).

## Stack

- Jekyll 4.x, built with Ruby/Bundler.
- Two template eras coexist: the current flat HTML+Liquid pages (home, `/blog`, `/learning`, `/cv`, all `layout: null`) share `css/theme.css`; individual blog posts still render through the older `_layouts/post.html` → `_layouts/default.html` layout chain.
- No JS build step — fonts/icons load from Google Fonts and Iconify CDNs, and any page scripts are plain inline `<script>` tags.

## Local setup

### Prerequisites

- Ruby 3.1 (matches the version CI builds with, see `.github/workflows/workflow.yml`). On macOS, `scripts/install_jekyl.sh` installs `chruby` + Ruby via Homebrew and wires up auto-switching in `~/.zshrc`.
- Bundler (`gem install bundler` if you didn't get it from the script above).

Install the Ruby dependencies from the `Gemfile`:

```sh
make install
```

(`make list-deps` prints the currently installed gems if you need to sanity-check the environment.)

For the homepage contact form to work locally, copy `_data/secrets.yml.example` to `_data/secrets.yml` and fill in a real Web3Forms key (gitignored, never committed - in CI this file is generated instead from the `WEB3FORMS_ACCESS_KEY` repo secret).

### Pre-commit hooks

This repo uses [pre-commit](https://pre-commit.com/) to catch YAML/workflow mistakes and basic hygiene issues before they're committed. One-time setup:

```sh
pip install pre-commit   # or: brew install pre-commit
pre-commit install
```

From then on, `git commit` automatically runs:

- `check-yaml`, `yamllint` (config: `.yamllint.yaml`) - YAML syntax and style, covers `.github/workflows/*.yml` and `_config.yml`
- `actionlint` - lints GitHub Actions workflows, including script-injection and shell issues in `run:` steps (install `shellcheck`, e.g. `brew install shellcheck`, to get the shell-script checks too)
- `check-merge-conflict`, `check-case-conflict`, `check-added-large-files`, `detect-private-key`, `end-of-file-fixer`, `trailing-whitespace`, `mixed-line-ending` - general hygiene

`markdownlint` (config: `.markdownlint.yaml`) is available on demand for `_posts/*.md` but isn't run automatically, since the existing posts have enough pre-existing style quirks that enforcing it on every commit would mostly flag old content:

```sh
pre-commit run markdownlint --hook-stage manual --files _posts/your-post.md
```

To run every hook against the whole repo (e.g. after changing `.pre-commit-config.yaml`):

```sh
pre-commit run --all-files
```

## Local testing of changes

```sh
make serve            # http://localhost:4000, with livereload
make serve PORT=8080   # or a different port
```

Before opening a PR, confirm a clean build succeeds the same way CI does:

```sh
make rebuild   # clean + install + build, output goes to _site/
```

`make clean` removes `_site/`, `.jekyll-cache/`, and `.bundle` if you need to start fresh.

## Adding a blog post

Add a file to `_posts/` named `YYYY-MM-DD-slug.md`:

```yaml
---
layout: post
title: "..."
date: YYYY-MM-DD
excerpt_separator: <!--more-->
tags: [Tag One, Tag Two]
---
```

Tags automatically show up as filter pills on `/blog` and beneath the post teaser on the homepage - no extra wiring needed.

## Branching model and deployment

| Branch | Purpose |
|---|---|
| `source` | Where you make all changes - Jekyll source: posts, includes, layouts, CSS, config. |
| `develop` | Integration branch, same Jekyll-source format as `source`. Only accepts merges from `source`. |
| `master` | Build output only. This is what GitHub Pages actually serves (custom domain `craftatscale.dev` via the `CNAME` file) - overwritten automatically by CI on every publish, never edit it directly. |
| `backup-*`, `*-04.07` | Legacy/snapshot branches, not part of the active deploy path - the workflow's `branch-policy` job rejects PRs from them. |

`.github/workflows/workflow.yml` enforces this shape (see the `branch-policy` job) and drives the pipeline itself:

1. **Write your change on a feature branch and open a PR into `source`.** CI builds the Jekyll site to validate it (including generating `_data/secrets.yml` from the `WEB3FORMS_ACCESS_KEY` secret, same as the local setup above). PRs from the legacy branches listed above are rejected - branch off the latest `source` instead.
2. **Once it's on `source`, open a PR from `source` into `develop` and merge it yourself** (also build-validated by CI). This is a normal, human-reviewed merge - `develop` holds the same Jekyll source as `source`, so the diff is real content, not build output. `branch-policy` only allows `source` as the head here.
3. **Merging that PR triggers the `deploy` job**, which builds the site once from `develop` and opens a PR from a bot branch (`promote/master-<sha>`) into `master`, then merges it itself. `branch-policy` only allows heads matching `promote/master-*` into `master`, so this is the only path that can update it.
4. **`master` is what GitHub Pages actually serves** - merging into it is the only thing that publishes anything live.

The `develop → master` promotion is fully automated (no manual approval step), since it's just "build what's already on `develop` and ship it" - the actual content review happens on the `source → develop` PR. If you want a manual gate before something goes live, remove the final `gh pr merge` call in the `deploy` job's "Promote build to master" step and merge that PR by hand instead.

### Required repository secrets

Set under Settings → Secrets and variables → Actions:

- `WEB3FORMS_ACCESS_KEY` - the Web3Forms access key for the homepage contact form, injected into `_data/secrets.yml` at build time.

No PAT is needed for deploys - the pipeline pushes and opens/merges its promotion PRs using the ephemeral `GITHUB_TOKEN`, scoped per job.

### Required repository settings

For the pipeline above to work, these need to be set in the GitHub repo settings (not in code):

- **Settings → Actions → General → Workflow permissions**: check "Allow GitHub Actions to create and approve pull requests" - required for the deploy job's `gh pr create`/`gh pr merge` calls.
- **Settings → Branches**: require a pull request before merging on `source`, `develop`, and `master`. You can require approvals on `source`/`develop` (both are human-merged), but **not** on `master` - a required-approval count there blocks the bot from self-merging the `develop → master` promotion.
- **Settings → Pages**: "deploy from a branch", branch `master`, folder `/`.
