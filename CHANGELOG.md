# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.2.3] - 2018-06-08
### Added
- CHANGELOG.md
- Convenience Bot.init(token: String) method

### Changed
- `HandlerCallback` signature now has `Update` and `BotContext` input params
- Now `debugMode` parameter in Bot.Settings is set `true` by default
- `Dispatcher` class made safer with special thread-safe `HandlersQueue` class
- Enqueue bot updates in special concurrent queue
- Updated README.md with super simple bot example

### Removed
- `DispatchStatus` enum

## [0.2.2] (2018-06-04)
### Added
- Webhooks updates server
