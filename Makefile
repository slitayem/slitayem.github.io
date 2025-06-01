# Building and previewing Jekyll site

SHELL := /bin/bash
# e.g. make serve PORT=8080

PORT := 4000

# Install jekyll, system-wide Jekyll dependencies and Bundler
list-deps:
	gem list --local

# Install Ruby dependencies via Bundler
install:
	bundle install

# Build the site into _site/
build:
	bundle exec jekyll build

# Serve the site locally with live reload
serve:
	bundle exec jekyll serve --livereload --port $(PORT) --open-url http://localhost:$(PORT)

# Clean generated site
clean:
	rm -rf _site .jekyll-cache .bundle

# Rebuild everything from scratch
rebuild: clean install build

help:
	@echo "Makefile targets:"
	@echo "  list-deps      - Install system-wide gems (jekyll-feed, jekyll-scholar, bundler)"
	@echo "  install   - Install Ruby dependencies from Gemfile"
	@echo "  build     - Build the site to _site/"
	@echo "  serve     - Serve site locally at http://localhost:$(PORT)"
	@echo "  clean     - Remove generated files"
	@echo "  rebuild   - Clean, install, and build"
