#!/usr/bin/env bash

# Install chruby and the latest Ruby
brew install chruby ruby-install
brew install ruby@3.1

# automatically use chruby
{
  echo ""
  echo "# Load chruby and auto-switching"
  echo "source \"\$(brew --prefix)/opt/chruby/share/chruby/chruby.sh\""
  echo "source \"\$(brew --prefix)/opt/chruby/share/chruby/auto.sh\""
  echo "chruby ruby-3.4.1"
} >> ~/.zshrc

# ruby -v
# gem install jekyll