# Project Design

The build is based on Makefile and Python, and only intended to support Linux.

The project repository mst only contain scripts and file templates (no binaries).

The project must be runnable with a short list of prerequisites, meaning it will install other requirements itself.

Installations / Download must all go into the caches folder (no sudo required, not installing anywhere else in user space).

It is possible that buildsystems write files to the userspace by their conventions (e.g. `~/.m2`, `~/.cache/pants`, ...). Where easily possible that should be redirected to the `caches` folder. But that is not a strict requirement.

Ideally all setting should be provided as defaults, but changeable in the custom defaults or benchmark configuration files. But that is not a strict requirement.

## Process Steps

1. Load persistent defaults (conventions)

2. Load custom default (personal conventions)

3. Load benchmark configuration with target name `{benchmark}`

4. For each Buildsystem `{buildsystem}`

   1. If requested, Download Java source from existing project (e.g. commons-math)
   2. Copy/Generate Java sources to `build/{benchmark}/{buildsystem}` (symlinking caused issues)
   3. Generate Buildsystem sources (e.g. pom.xml) to `build/{benchmark}/{buildsystem}`
   4. Download the Buildsystem {buildsystem} to `caches`
   5. Execute Buildsystem {buildsystem} within `build/{benchmark}/{buildsystem}`
   6. Harvest Benchmark results into `build/{benchmark}/repots/{buildsystem}.yaml`

## Files and Folders

In order to allow configuring different combinations of Java-sources, buildsystem-sources, and buildsystem versions, several independent subfolder trees exist for each purpose.

The `caches` and `build` folders are never checked in, their content can be deleted at any time, and a build must be able to recreate those folders as necessary when required.

Showing the tree structure for example Apache Ant.

    build-bench
    ├── Makefile               // Drives the whole build, main entry point
    ├── build                  // not checked in, all output during benchmark run should go here
    │   ├── multi-2-3
    │   │   ├── ant_ivy1.9.6   // copied Java sources and build files
    │   │   │   ├── build.xml
    │   │   │   ├── src
    │   │   │   ├── ...
    ├── buildsystems
    │   ├── ant_ivy
    │   │   └── Makefile    // downloads ant+ivy and runs benchmark
    │   ├── ...
    ├── buildtemplates
    │   ├── multiModule     // ant-specific buildfiles (any version of ant)
    │   │   ├── ant_ivy
    │   │   │   ├── build.xml
    │   │   │   ├── dependencies.xml.tmpl
    │   │   │   └── subprojectPROINDEX
    │   │   │       ├── build.xml.tmpl
    │   │   │       └── ivy.xml
    │   │   ├── ...
    │   └── singleModule
    │       ├── ant_ivy
    │       │   ├── build.xml
    │       │   └── ivy.xml
    │       ├── ...
    ├── caches                  // not checked in, downloaded buildsystems and sources
    │   ├── ant_ivy
    │   │   ├── ant_ivy1.9.6    // cached ant + ivy version 1.9.6
    │   │   ├── ...
    │   ├── commons-math        // cached downloaded sources
    │   │   ├── ...
    │   ├── ...
    ├── configs // Variables driving the benchmarks
    │   ├── commons-math.mk          // specific benchmark project definition
    │   ├── defaults.mk              // global persistent defaults
    │   ├── generated_minimal.mk
    │   ├── generated_multi.mk
    │   └── generated_single.mk
    ├── generators
    │   ├── commons-math
    │   │   └── Makefile             // download common-maths source from Apache
    │   ├── multi
    │   │   ├── Makefile             // install source tree to build
    │   │   └── subprojectPROINDEX
    │   │       └── src
    │   │           ├── main
    │   │           │   └── java
    │   │           │       └── comPROINDEX
    │   │           │           └── SimpleINDEX.java.looptmpl
    │   │           └── test
    │   │               └── java
    │   │                   └── comPROINDEX
    │   │                       └── SimpleINDEXTest.java.looptmpl
    │   └── simple
    │       ├── Makefile              // install source tree to build
    │       └── src
    │           ├── ...
    ├── include                       // reusable Makefile snippets
    │   ├── ant.mk
    │   ├── includes.mk
    │   ├── jinja2_generate.mk
    │   ├── leiningen.mk
    │   └── time.mk
    └── scripts
        └── apply-templates.py        // instantiates templates recursively

## Jinja2 file generation

The python script `scripts/apply-templates.py` scans a given folder tree, and copies file to a target folder, maintaining directory structure. The Script currently has 2 nested loops, one for subprojects, one for files.

When it encounters a file or folder containing `PROINDEX` in the name, it will duplicate this file/folder into the target substituting `PROINDEX` with the loop index (0, 1, 2 ...).
Similarly for files containing `INDEX`, in a nested loop.

When the filename ends in `tmpl`, the script will run jinja2 and put the output of that to the target folder in a file named as the original but without the suffic `tmpl` (e.g. Test.javatmpl -> Test.java).

In templates, defined variables can be used according to Jinja2 rules.
