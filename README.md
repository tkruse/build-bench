# build-bench

A Benchmark setup for Java buildsystems.

[![Build Status](https://travis-ci.org/tkruse/build-bench.svg)](https://travis-ci.org/tkruse/build-bench)

The different buildsystems are installed locally on demand by the makefiles.

Buildsystems:
* Apache Ant  (http://ant.apache.org)
* Gradle  (https://gradle.org)
* Apache Maven  (http://maven.apache.org)
* Apache Buildr (http://buildr.apache.org)
* Sbt  (http://www.scala-sbt.org)
* Leiningen  (http://leiningen.org)
* Buck  (https://buckbuild.com)
* Pants  (https://pantsbuild.github.io)
* Bazel  (http://bazel.io)

Also see [my notes](Buildsystems.md)

## Running

```
# to run all buildsystems
$ make

# to run all buildsystems freshly
$ make clean all

# to run for just selected buildsystems, e.g. maven vs. gradle:
$ make clean maven gradle
```

The process is configured using variables that can be changed, the configs folder has a ```defauls.mk``` file setting defaults, and some example files for different kinds of builds.

It is possible to run a custom Benchmark configuration using:

```
# to run specific configuration
$ make clean all CONFIG=configs/generated_multi.mk
```


## Prerequisites

* Java        (7 or 8, configure JAVA_HOME)
* bash        (the standard Ubuntu shell)
* GNU make    (should be present on any *nix)
* GNU time    (should be present on any *nix)
* Python      (2 or 3)
* jinja2      (if using templated sources, install via pip or apt-get)
* Ruby        (1 or 2, for Apache buildr, jruby should also work)

## Configuring Benchmarks

Custom configurations are loaded after the ```defaults.mk``` providing some convention over configuration. If present, a ```custom.mk``` in the project root will be loaded after ```default.mk``` but before specific configuration, allowing to override permanent defaults with your defaults.


## Motivation

While Maven and Gradle are used by most Java projects in the wild, there are many alternatives to choose from. Comparing those is difficult. This project is a setup to run a buildprocess for java projects using multiple buildsystems.
It can serve to benchmark buildsystems, or just to compare features.

The project is driven using GNU make. The ```Makefile``` creates a ```build``` folder,
containing a folder structure for benchmarks. Subfolders follow the pattern ```<benchmarkname>/<buildsystemname>```. Into those folders, Java source files and buildsystem specific files will be copied / generated. Then t eh buildsystem is invoked inside that folder and the time until completion is measured.


## Samples

The builds should work for any source tree that follows these conventions:
* Java 8 compliant code
* Java sources in src/main/java
* Test sources in src/test/java
* Other test resources in src/test/resources
* Tests written in JUnit4.11 compatible fashion, not requiring 4.12 (sbt issues)
* Test classes named *Test.java
* Abstract Test parent classes named *AbstractTest.java (to be excluded, some buildsystems fail else)
* Single module projects (as opposed to multi-project builds)
* No other dependencies than standard Java and JUnit4


## Output

Sample output (manually cleaned up) for a clean build of apache commons.math (compile + test).
Most of the time spend is on actually running tests.

```
$ make versions
java version "1.7.0_80"
Apache Maven 3.3.3 (7994120775791599e205a5524ec3e0dfe41d4a06; 2015-04-22T13:57:37+02:00)
Gradle 2.6
sbt sbtVersion 0.13.9
Buildr 1.4.23
buck version 92f4a5486d453 (Sep 2015)
Leiningen 2.5.2 on Java 1.7.0_80 Java HotSpot(TM) 64-Bit Server VM
Apache Ant(TM) version 1.9.6 compiled on June 29 2015
bazel version Sep 06, 2015
pants --version: 0.0.46

$ make clean-builds all --silent
******* sbt start (invalid, skipped tests for unknown reasons)
cd build/sbt; time sbt -java-home /usr/lib/jvm/java-7-oracle/ -q test package
368.03user 3.29system 1:16.01elapsed 488%CPU (0avgtext+0avgdata 1289052maxresident)k
129320inputs+115696outputs (114major+496608minor)pagefaults 0swaps
******* buildr start
cd build/buildr; time buildr -q package
234.25user 3.96system 2:27.34elapsed 161%CPU (0avgtext+0avgdata 1032168maxresident)k
31848inputs+122104outputs (47major+798859minor)pagefaults 0swaps
******* maven start
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
221.38user 3.85system 2:30.19elapsed 149%CPU (0avgtext+0avgdata 993952maxresident)k
127240inputs+67960outputs (102major+626805minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q jar
238.31user 4.82system 2:28.01elapsed 164%CPU (0avgtext+0avgdata 1003468maxresident)k
220784inputs+58840outputs (369major+661382minor)pagefaults 0swaps
******* buck start
cd build/buck; time buck test
0.07user 0.14system 2:34.22elapsed 0%CPU (0avgtext+0avgdata 8508maxresident)k
6128inputs+24outputs (36major+12564minor)pagefaults 0swaps
******* pants start
cd build/pants; time pants test :test -q
223.78user 4.60system 2:45.22elapsed 138%CPU (0avgtext+0avgdata 835920maxresident)k
117016inputs+62184outputs (196major+754749minor)pagefaults 0swaps
******* bazel start
cd build/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests
0.27user 0.13system 2:50.71elapsed 0%CPU (0avgtext+0avgdata 52272maxresident)k
86816inputs+138488outputs (70major+13539minor)pagefaults 0swaps
******* ant-ivy start
cd build/ivy; time ant jar -q
437.16user 21.80system 5:05.07elapsed 150%CPU (0avgtext+0avgdata 875420maxresident)k
224576inputs+186168outputs (371major+6421924minor)pagefaults 0swaps
******* leiningen start
cd build/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'
373.26user 28.06system 8:41.61elapsed 76%CPU (0avgtext+0avgdata 862632maxresident)k
45552inputs+244352outputs (21major+7072416minor)pagefaults 0swaps


### second build

$ make all --silent
******* bazel start
cd build/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests
0.00user 0.00system 0:00.80elapsed 1%CPU (0avgtext+0avgdata 2580maxresident)k
17608inputs+8outputs (67major+772minor)pagefaults 0swaps
******* buildr start
cd build/buildr; time buildr -q package
0.90user 0.09system 0:01.13elapsed 88%CPU (0avgtext+0avgdata 27216maxresident)k
41248inputs+0outputs (40major+10987minor)pagefaults 0swaps
******* buck start
cd build/buck; time buck test
0.06user 0.13system 0:02.21elapsed 8%CPU (0avgtext+0avgdata 8576maxresident)k
64424inputs+24outputs (181major+12099minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q test jar
6.74user 0.27system 0:04.70elapsed 149%CPU (0avgtext+0avgdata 244752maxresident)k
54840inputs+464outputs (122major+49538minor)pagefaults 0swaps
******* sbt start
cd build/sbt; time sbt -java-home /usr/lib/jvm/java-7-oracle/ -q test package
364.05user 1.59system 0:59.35elapsed 616%CPU (0avgtext+0avgdata 1098980maxresident)k
107488inputs+10504outputs (60major+374811minor)pagefaults 0swaps
******* pants start
cd build/pants; time pants test :test -q
199.23user 3.09system 2:12.04elapsed 153%CPU (0avgtext+0avgdata 727832maxresident)k
137808inputs+12744outputs (62major+378548minor)pagefaults 0swaps
******* maven start (problems with incremental build: MCOMPILER-209, MCOMPILER-205)
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
218.67user 4.04system 2:18.44elapsed 160%CPU (0avgtext+0avgdata 987708maxresident)k
64248inputs+39400outputs (76major+628412minor)pagefaults 0swaps
******* ant-ivy start
cd build/ivy; time ant jar -q
404.38user 18.92system 4:40.69elapsed 150%CPU (0avgtext+0avgdata 878216maxresident)k
57080inputs+132280outputs (28major+5336293minor)pagefaults 0swaps
******* leiningen start
cd build/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'
343.99user 26.14system 8:17.16elapsed 74%CPU (0avgtext+0avgdata 848440maxresident)k
119080inputs+115680outputs (31major+6769056minor)pagefaults 0swaps

```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md)

## FAQ

### What influences performance?

JVM startup adds something like 3 seconds to the whole process. Several tools offer daemons to reduce this offset. Tools not written in JVM languages do not have this offset.

Parallel task execution: On machines with multiple cores, it may be possible to reduce build time by utilizing more than one CPU. However the build-time rarely is reduced by the number of CPUs. The overhead of finding out how to split tasks over several CPUs can eliminate benefits, and often there will be many dependencies that lead to tasks necessarily being build in sequence. Most buildtool will thus mostly offer to only build completely independent sub-modules in parallel. For single-module projects, no additional CPU is used then.
Some tasks may even only work when not run in parallel, so using parallel fatures also increases maintenance effort.

Compiler speed may differ for different compilers. The scala compiler and clojure compiler seemed slower than javac for compiling java sources.

Incremental re-compilation, meaning compiling only files that are affected by a change, can drastically reduce build times.

Incremental build steps beond compilation help (e.g. Maven can compile incrementally, but not test incrementally).

Caching influences incremental builds. Several buildsystems have a simple caching strategy in that they will not run a task if the output still exist. This will improve performance for repeated builds.

Buck, Bazel and Pants were the only build system benchmarked here that offers advanced (true) caching of build results, in that the cache is an independent storage that maintains multiple versions of build results over time. This can dramatically reduce build times in many more situations than simple caching described before.

For large projects with plenty of subprojects and subtasks, performance can be gained by caching in a fine-grained way and reusing more previous artifacts. The example and setup used in this benchmark may not be optimal for any given buildsystem. In particular, Pants has some online examples defining plenty of smaller library targets for individual Java files, which might improve caching performance when rebuilding after a single java file changed (not sure what other advantage it could have).

### So which buildsystem should I use for Java projects?

It depends on what you need.

To choose, consider the following:

- Learning curve
- Maturity
- Performance (startup, parallelism, compiler, incremental builds, caching)
- Documentation
- Community size
- IDE support
- Plugin archives, integration with static code analysis, metrics, reports, etc.
- multi language support

### No really, which one should I use for Java projects?

Maven or Gradle are the default choice for most open-source Java projects and many businesses out there. Maven may still be more popular in the industry for stability, but Gradle has a stronger innovation drive. Both have hundreds of open-source plugins available, and both get special support from IDEs, Continuous integration servers, etc. I personally prefer Gradle and give some details about what I dislike about Maven below.

Buildr seems to be mostly similar to Gradle but written in Ruby, which offers some advantages and disadvantages. It does not seem to gain the kind of market share Gradle and Maven have established.

Ant is still being used, but it's unclear what advantages it offers. Maybe simplicity for creating many small unconventional tasks. Gant is built on top of ant and similar in purpose, but allowing to write in Groovy. Other buildsystems like make, rake or scons might be similar enough to ant, but they do not get further consideration here because they have little tradition for Java projects.

Leiningen and sbt are optimized (in usability) for Clojure and Scala respectively. If you only use Java, it probably does not pay off to use either of them, unless you wanted to learn / integrate those languages anyway.

Bazel and Pants are derived from Googles Blaze system optimized for huge monorepo corporate ecosystems, where thousands of projects with interdependencies are continuously build and deployed. Buck is used at Facebook, Pants at Twitter.
They shine in build speed and caching, but they require more developer attention and effort, because they are rule based, and have no high-level abstraction of a project object model like Gradle or Maven. And being still fairly new as open-source projects at this time, they do not have the mature support from other open-source tools. As an example, buck only lately got a feature to automatically download dependencies from central Maven repositories.
Since they have been used in a corporate setting where strict standards could be enforced, they are prone to detection of new bugs when being used in the wild by projects following a huge variety of conventions.

Buck is mainly targetted at building Java apps for Android, it is inspired by Blaze.

Name | Target | language | Written in | Since | Support | Caching | Model 
---- | ------ | -------- | ---------- | ----- | ------- | ------- | -----
ant       | Java                       | XML        | Java         | 2000 | Apache | None | rules
maven     | Java (Scala, Ruby, C#)     | XML        | Java         | 2002 | Apache | None | POM  
gradle    | Java, Groovy (Scala, C++,) | Groovy     | Java, Groovy | 2007 | Gradleware | last build | POM
buildr    | Java                       | Ruby       | Ruby         | 2010? | Apache | ? | POM
sbt       | Scala, Java                | Scala      | Scala        | 2010? | ? | ? | POM 
leiningen | Clojure, Java              | Clojure    | Clojure      | 2009? | ? | ? | POM 
buck      | Java (Android)             | Python-ish | Java, Python | 2012        | Facebook | true cache | rules
bazel     | C++, Java, Python, Go      | Python-ish | C++, Java    | 2015 (2005?)| Google | true cache | rules
pants     | Java, Scala, Python, Go    | Python     | Python       | 2014 (2010) | Twitter | true cache | rules


### Why are ant/sbt/leiningen so slow for clean testing of commons-math?

I do not know for sure. There must be some overhead not present in the other systems, maybe a new JVM process is started for each test.

Note that for sbt and leiningen, extra plugins were required to run JUnit tests written in Java. These buildsystems would specialize on tests written in Scala/Clojure, and the results here do not tell whether tests written in Scala or Clojure would have similar overheads.


### I get InstantiationExceptions with some buildsystem, what is going on?

java.lang.InstantiationException during tests is usually a sign that a TestRunner is trying to run a non-Testcase class (like abstract or util classes). Not all Buildsystems can cope well with that by default.

### Why GNU make?

I chose GNU make for this project because it is omnipresent in linux and very close to shell scripting.

### Why jinja2?

I needed some templating engine, and scripting in Python seemed the least effort. Jinja2 is popular and een around for a while. Mako and Genshi also seemed nice at a glance.

### Why commons-math?

I chose to test against commons-math because it is reasonably large, well tested, and has no dependencies outside the JDK. Other libraries working okay are commons-text, commons-io, commons-imaging, guava.

The main problems I had with commons-math was that the naming for the Testcases is not consistent. the commons-math ant file lists those rules:
```
<include name="**/*Test.java"/>
<include name="**/*TestBinary.java"/>
<include name="**/*TestPermutations.java"/>
<exclude name="**/*AbstractTest.java"/>
```
And even those do not cover all Testcases defined in the codebase.


