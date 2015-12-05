## Contributions

I welcome anyone who wants to add something.

Open tasks:

- Simple tweaks for individual buildsystems (they should remain realistic)
- downloading of dependencies to location cached between builds (ant, buck)
- templated configuration of builds (java version, dependencies)
- Parsing the output of time and generating pretty reports / graphs (use time -o -f, then collect results)
- sbt using junit 4.12
- Integrate other tools (checkstyle, Findbugs, PMD)
- Integrate other test frameworks (Testng, spock)
- interesting scalable generated sources
- optionally run tests/tasks in parallel using n CPUs
- Add skeletton build files to arbitrary projects with flat parent/submodule structure. Possibly define meta-buildsystem with hooks.
- Refactor Buildsystem knowledge in declarative way, allowing to easily benchmark multiple versions of same buildsystem, same buildsystem with different options, ...
- use / preheat gradle daemon and similar
- maven parallel builds
- custom-defaults
- download jinja2
- download JRE
- sanitized contained envs (PATH, CLASSPATH, PYTHONPATH, RUBY, *_HOME, virtualenv, .cache)
- draw sequence diagram of Makefilebuild
- allow local installs
- provide cached files?
- install GNU time on travis without sudo (http://codingsnippets.com/linux-simple-benchmark-with-gnu-time/)
- configure apache download mirror centrally
