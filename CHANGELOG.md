# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-11-19

### Added
- `AssessmentTypesResource#list_by_family`, which requests the detailed `position_get` payload (`extra_info` and `cmd_ver`) and returns assessment families with their positions and languages.
- `AssessmentFamily`, with `id`, `name`, `title`, `languages`, and `assessment_types` wrappers. `assessment_types` aliases `positions`. API fields such as `report_id` and `deactivated` stay available. `assessment_types.list` is unchanged.
- `AssessmentsResource#scores` accepts `for_sibling_position_id` as an alias for `pos_ovr_id` when recalculating a score for another position in the same family.

## [0.2.0] - 2026-07-15

### Changed
- Modernized `PopEngine::Client` connection syntax to use `conn.request :basic_auth` instead of the deprecated `conn.basic_auth` helper method.
- Tightened Faraday version constraints in `pop_engine.gemspec` to target `>= 1.0, < 3.0`, dropping support for legacy Faraday 0.x.

## [0.1.0] - 2025-11-12
- Initial release of the `pop-engine` gem for communicating with the PopEngine API.
