# slitayem.github.io

Personal website — a Jekyll site served via GitHub Pages.

## Stack

- Jekyll 4.x, built with Ruby/Bundler.
- Two template eras coexist: the current flat HTML+Liquid pages (home, `/blog`, `/learning`, `/cv`, all `layout: null`) share `css/theme.css`; individual blog posts still render through the older `_layouts/post.html` → `_layouts/default.html` layout chain.
- No JS build step — fonts/icons load from Google Fonts and Iconify CDNs, and any page scripts are plain inline `<script>` tags.

## Branch model

| Branch | Purpose |
|---|---|
| `source` | Where you make all changes — Jekyll source: posts, includes, layouts, CSS, config. |
| `master` | Build output only. This is what GitHub Pages actually serves at slitayem.github.io. It's overwritten automatically by CI on every publish — never edit it directly. |
| `develop`, `backup-*` | Older/snapshot branches, not part of the active deploy path. |

## Deployment pipeline

Defined in `.github/workflows/workflow.yml`. Any push to a branch other than `master` triggers it:

1. **Checkout** — always checks out `source` (hardcoded), regardless of which branch triggered the run.
2. **Set up Ruby** 3.1.
3. **Inject secrets** — writes `_data/secrets.yml` from the `WEB3FORMS_ACCESS_KEY` repo secret, so the contact form's Web3Forms key never lives in source control (see `_data/secrets.yml.example` for the local equivalent).
4. **Build** — `make rebuild` (clean → `bundle install` → `jekyll build` into `_site/`).
5. **Deploy** — only runs if the *triggering* branch was `source`:
   - Checks out `master`.
   - Wipes everything except the freshly built `_site/`, then moves its contents to the branch root.
   - Runs `make clean` to drop build artifacts.
   - Commits and pushes the result to `master` using the `JEKYLL_TOKEN` secret.

Net effect: **push to `source` → CI builds the site → publishes the compiled HTML/CSS to `master` → GitHub Pages serves it.** There's no manual build or deploy step — pushing to `source` is the whole release process. Pushes to any other non-`master` branch (e.g. a feature branch) will build and validate but skip the deploy step.

## Required repository secrets

Set under Settings → Secrets and variables → Actions:

- `JEKYLL_TOKEN` — a token with push access to this repo, used to publish the built site to `master`.
- `WEB3FORMS_ACCESS_KEY` — the Web3Forms access key for the homepage contact form, injected at build time.

## Local development

```
make install   # bundle install
make build     # jekyll build -> _site/
make serve     # jekyll serve --livereload at http://localhost:4000
make clean     # remove _site, .jekyll-cache, .bundle
make rebuild   # clean + install + build
```

For the contact form to work locally, copy `_data/secrets.yml.example` to `_data/secrets.yml` and fill in a real key (gitignored, never committed).

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

Tags automatically show up as filter pills on `/blog` and beneath the post teaser on the homepage — no extra wiring needed.

## Publishing

Commit to `source` and push. The workflow above handles the build and publish to `master` automatically.
