## [v0.8.1](https://github.com/gha3mi/fortime/compare/v0.8.0...v0.8.1) - 2026-05-07


### Fixes

* fix: rename .f90 to .F90 ([4fbe811](https://github.com/gha3mi/fortime/commit/4fbe8112387a02b156648fc90a42320b03ada6c2)) by [@gha3mi](https://github.com/gha3mi)
* fix: add options for OpenMP and MPI support in CMake configuration ([9569b17](https://github.com/gha3mi/fortime/commit/9569b171a118c5cbbfa0e5d0d5cb9dd8682aef09)) by [@gha3mi](https://github.com/gha3mi)
* fix: avoid mpi module dependency in non-MPI scans ([d6264ad](https://github.com/gha3mi/fortime/commit/d6264ad28cc583b3b674967b0c16703f4d250ffa)) by [@gha3mi](https://github.com/gha3mi)
* fix: release.sh URL ([d826f88](https://github.com/gha3mi/fortime/commit/d826f889f755dbde872d3f0d6b05aaa6ca86b99f)) by [@gha3mi](https://github.com/gha3mi)

### Others

* refactor: remove unused variable 'nunit' from timer write subroutines ([f4d0246](https://github.com/gha3mi/fortime/commit/f4d0246a2639950fa69ddbeb2e441e5c15709be3)) by [@gha3mi](https://github.com/gha3mi)
* chore: update fpm.toml metadata ([1f2b01a](https://github.com/gha3mi/fortime/commit/1f2b01a2bd42701a72161fcdb383df1221b70e1c)) by [@gha3mi](https://github.com/gha3mi)
* Update CI ([b21287b](https://github.com/gha3mi/fortime/commit/b21287ba46953f0fed4fe5bd12d60c2fa4b0b705)) by [@gha3mi](https://github.com/gha3mi)
* refactor: improve timer internals and API docs ([73169fd](https://github.com/gha3mi/fortime/commit/73169fdb7572d561e5629a6f86df0867bf60ea1a)) by [@gha3mi](https://github.com/gha3mi)
* test: replace individual tests with a single check ([3d4262a](https://github.com/gha3mi/fortime/commit/3d4262a19f2ae1469b832efd84d69deda0460aa6)) by [@gha3mi](https://github.com/gha3mi)
* chore: update copyright year ([fe04a0f](https://github.com/gha3mi/fortime/commit/fe04a0fbc3ee7c3f431733e72423628764b9d1a1)) by [@gha3mi](https://github.com/gha3mi)
* chore: update ignore rules in fpm.toml ([c09d8d6](https://github.com/gha3mi/fortime/commit/c09d8d6ee9497e7e6fbdcca5c8cd063ac9d45585)) by [@gha3mi](https://github.com/gha3mi)
* docs: Update README.md ([ece1601](https://github.com/gha3mi/fortime/commit/ece1601a753e3bdd9ba02ce809c29aceaaa11112)) by [@gha3mi](https://github.com/gha3mi)
* ci: update CI-CD workflow ([caa7cda](https://github.com/gha3mi/fortime/commit/caa7cdaaf19f5c916f9207759d5cc118c7561a53)) by [@gha3mi](https://github.com/gha3mi)
* ci: fix Ford output dir ([5d54f4c](https://github.com/gha3mi/fortime/commit/5d54f4c051ec9021c18e5c4a5b969f13667522ff)) by [@gha3mi](https://github.com/gha3mi)
* Update README.md status table [ci skip] (#9) ([c033ec8](https://github.com/gha3mi/fortime/commit/c033ec8e43ef3d8b253eb81ecd1f6cbe578c0d17)) by [@gha3mi](https://github.com/gha3mi)


### Contributors
- [@gha3mi](https://github.com/gha3mi)



Full Changelog: [v0.8.0...v0.8.1](https://github.com/gha3mi/fortime/compare/v0.8.0...v0.8.1)

## [v0.8.0](https://github.com/gha3mi/fortime/compare/v0.7.0...v0.8.0) - 2025-08-11


### Features

* feat: add optional format parameter to timer stop ([d5da53a](https://github.com/gha3mi/fortime/commit/d5da53ac971be2b1b4c4cd1e46bd1136ae857f6a)) by [@gha3mi](https://github.com/gha3mi)

### Others

* chore: update release.sh ([06eeb42](https://github.com/gha3mi/fortime/commit/06eeb42aa08f84d958bfd03545cf76eff848ab1a)) by [@gha3mi](https://github.com/gha3mi)
* docs: update README [skip ci] ([ea10b68](https://github.com/gha3mi/fortime/commit/ea10b68df1957cefc003457c46d29821170be497)) by [@gha3mi](https://github.com/gha3mi)
* docs: fix badge ([099a701](https://github.com/gha3mi/fortime/commit/099a7012dcd48872f73bd30fcc3105835463bfae)) by [@gha3mi](https://github.com/gha3mi)


### Contributors
- [@gha3mi](https://github.com/gha3mi)



Full Changelog: [v0.7.0...v0.8.0](https://github.com/gha3mi/fortime/compare/v0.7.0...v0.8.0)

## [v0.7.0](https://github.com/gha3mi/fortime/compare/v0.6.1...v0.7.0) - 2025-07-22


### Features

* feat: add fpm.rsp for CI workflows ([a0a9417](https://github.com/gha3mi/fortime/commit/a0a94175eeebeca7dcd02a7dbac3dd23027d9fc9)) by [@gha3mi](https://github.com/gha3mi)
* feat: enhance CI/CD workflow with CMake testing and status generation ([d2310a3](https://github.com/gha3mi/fortime/commit/d2310a3f723db0b285ba7829ac6867fee1444772)) by [@gha3mi](https://github.com/gha3mi)
* feat: add release.sh script for automated changelog generation and versioning ([3c91c0e](https://github.com/gha3mi/fortime/commit/3c91c0e103954dd0c68746e32af153581fe4df05)) by [@gha3mi](https://github.com/gha3mi)

### Fixes

* fix: use VERSION file to determine version ([6108527](https://github.com/gha3mi/fortime/commit/6108527de87bde04984aea94eb810e353f1ddb85)) by [@gha3mi](https://github.com/gha3mi)
* fix: remove unused variables from timer write subroutines ([431c675](https://github.com/gha3mi/fortime/commit/431c67563e4254acf62d9e1caa062d70340cbebc)) by [@gha3mi](https://github.com/gha3mi)
* fix: add use only ([185ee7f](https://github.com/gha3mi/fortime/commit/185ee7ff005af45f39ce2f49dd40f1938501e460)) by [@gha3mi](https://github.com/gha3mi)
* fix: update ignored codes in fortitude check ([3f4583a](https://github.com/gha3mi/fortime/commit/3f4583ad86899eee3c70bbe655663e7b76e3d872)) by [@gha3mi](https://github.com/gha3mi)

### Others

* update README.md status table ([#6](https://github.com/gha3mi/fortime/pull/6)) by [@gha3mi](https://github.com/gha3mi)
* use setup-fortran-conda ([d7ce243](https://github.com/gha3mi/fortime/commit/d7ce24351cbd907adf2cedb2b7f2ce09855ce59a)) by [@gha3mi](https://github.com/gha3mi)
* Add Fortitude Linter job to CI/CD workflow ([4a1d8ef](https://github.com/gha3mi/fortime/commit/4a1d8efde64188726388dab45f5d12d2201120cd)) by [@gha3mi](https://github.com/gha3mi)
* refactor: update CMakeLists.txt ([9ff7212](https://github.com/gha3mi/fortime/commit/9ff7212a6fba8b7d5b99368ff67d3c6d6058e361)) by [@gha3mi](https://github.com/gha3mi)
* Update README.md status table [ci skip] (#8) ([c75de7d](https://github.com/gha3mi/fortime/commit/c75de7d11d84ad9395af76ed59d80b06f5b2bebe)) by [@gha3mi](https://github.com/gha3mi)


### Contributors
- [@gha3mi](https://github.com/gha3mi)



Full Changelog: [v0.6.1...v0.7.0](https://github.com/gha3mi/fortime/compare/v0.6.1...v0.7.0)
