# 2. Initial architecture decisions

Date: 2025-04-02

## Status

Accepted

## Context

We need to choose the initial language and framework for the saml_proxy application.

## Decision

We will use:

* Language: Ruby
* Framework: Rails with unused frameworks disabled.
* Unit tests: RSpec
* Javascript bundler: webpack

## Consequences

Ruby on Rails is a common development environment for the developers on this team, leading to faster development timelines.
