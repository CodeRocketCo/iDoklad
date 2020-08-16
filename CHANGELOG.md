# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- use API v3 (https://api.idoklad.cz/Help/v3/cs/#apiDiff)
## [1.1.0] - 2019-07-23
### Changed
- base model attributes switched underscore to camelcase
### Added
- create / update / destroy
- response errors
- .first method = for return first record :)
### Fixed
- Content-Type header in post
### Removed
- class-instance variable @response
## [1.0.3] - 2019-07-18
### Added
- store @response in variable
- try to log ParseError 
- access_token expiration reloader
### Changed
- remove token cache from Idoklad::ApiRequest and move it to Idoklad::Auth with multi-tenancy support
## [1.0.2] - 2019-06-09
### Added
- ParamsParser for convert model args to iDoklad query 
### Fixed
- some typo
## [1.0.1] - 2019-06-03
### Fixed
- class variable inheritance (entity_name)
### Added
- Currency entity model
- ApiLimit model 
- IssuedInvoice statuses
## [1.0.0] - 2019-06-02
### Added
- subclasses structure of iDoklad entities
- IssuedInvoice
### Changed
- refactor current code
