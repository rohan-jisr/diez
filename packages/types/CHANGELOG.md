# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

# [10.0.0-alpha.8](https://github.com/diez/diez/compare/v10.0.0-alpha.0...v10.0.0-alpha.8) (2019-06-14)


### Features

* **compiler:** enable fully ejectable Diez SDKs for Android and web ([#97](https://github.com/diez/diez/issues/97)) ([4b57a8e](https://github.com/diez/diez/commit/4b57a8e))
* **createproject:** add simple start-* scripts for `diez create` example projects ([#147](https://github.com/diez/diez/issues/147)) ([5711743](https://github.com/diez/diez/commit/5711743))


### BREAKING CHANGES

* **compiler:** the `diez compile` command no longer uses an `--outputPath/-o` flag for directing SDK output to a specified directory nor a `--devMode/-d` flag for running "hot", and instead builds SDKs into `build/` in unique directories per project/target like `build/diez-poodle-surf-ios`.