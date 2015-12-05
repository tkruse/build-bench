## Contributions

I welcome anyone who wants to add something.

Open tasks:

- Parsing the output of time and generating pretty reports / graphs (use time -o -f, then collect results)
- sbt using junit 4.12
- Add skeletton build files to arbitrary projects with flat parent/submodule structure. Possibly define meta-buildsystem with hooks.
- Simple tweaks for individual buildsystems (they should remain realistic)
- templated configuration of builds (java version, dependencies)
- Integrate other tools (checkstyle, Findbugs, PMD)
- Integrate other test frameworks (Testng, spock)
- interesting scalable generated sources
- optionally run tests/tasks in parallel using n CPUs
- Refactor Buildsystem knowledge in declarative way, allowing to easily benchmark multiple versions of same buildsystem, same buildsystem with different options, ...
- sanitized contained envs (PATH, CLASSPATH, PYTHONPATH, RUBY, *_HOME, virtualenv, .cache)
- draw sequence diagram of Makefilebuild
- allow local installs instead of downloaded
- configure apache download mirror centrally
- Make Makefile subdirectories self-sustaining (global includes file)
