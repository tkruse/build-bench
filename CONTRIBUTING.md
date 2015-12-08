---
layout: default
---
# Contributions

I welcome anyone who wants to add something.

Open tasks:

* pants global caches within caches folder
* clean global caches (global-clean)
* measure # generated files
* sbt using junit 4.12
* table output
* Nicely collect benchmark results
* Use Linux `perf` instead of `time`?
* Provide log and zipped sources
* Simple tweaks for individual buildsystems (they should remain realistic)
  * sbt less system resources
  * optionally run tests/tasks in parallel using n CPU
* templated configuration of builds (java version, dependencies)
* Integrate other tools (checkstyle, Findbugs, PMD)
* Integrate other test frameworks (Testng, spock)
* interesting scalable generated sources
* sanitized contained envs (PATH, CLASSPATH, PYTHONPATH, RUBY, *_HOME, virtualenv, .cache)
* allow local installs instead of downloaded
* configure download mirrors centrally
* Add skeletton build files to arbitrary projects with flat parent/submodule structure. Possibly define meta-buildsystem with hooks.
* Allow users to easily submit their results, incorporate into statistical plot
* Consider other language build tools
