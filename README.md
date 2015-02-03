# build-bench

Benchmark setup for Java buildsystems.

While Maven and Gradle are used by most Java projects in the wild, there are many alternatives to choose from. Comparing those is difficult. This project is a setup to run a buildprocess for java projects using multiple buildsystems.
It can serve to benchmark buildsystems, or just to compare features.

The project works mostly well using Apache commons-math as sample source. However, benchmarking of special features like bucks caching would benefit more from a multi-module setup.

Manual installation of the different buildsystems is required.

The project is driven using GNU make. The ```Makefile``` creates a ```build``` folder,
containing a ```src``` folder, which is expected to contain sources in the canonical layout (```src/main/java``` etc.)
Then it creates project setups for each buildsystem inside
```build/<buildsystemname>``` with a softlink to ```src```.
Then it invokes the build command to compile, unit-test and jar the sources.

## Running

```
# to run all buildsystems
$ make clean-builds all --silent

# to run for just selected buildsystems, e.g. maven vs. gradle:
$ make clean-builds maven gradle
```

In case you want to run with other projects, modify the ```Makefile``` as required.

# Prerequisites

* bash     (the standard Ubuntu shell)
* GNU make    (should be present on any *nix)
* cheetah    (if using templated sources, install via pip or apt-get)

# Buildsystems

## ant + ivy

ant is packaged for Ubuntu.
For more recent version see: http://ant.apache.org/manual/install.html

## Maven

Installing a 3.x version should be easy, it is packaged for Ubuntu.
E.g.

$ sudo apt-get install maven3

More recent versios can be found at: http://maven.apache.org/download.cgi

## Gradle

I recommend ```gvm``` for gradle: http://gvmtool.net/

## Leiningen

Leiningen has an installer for Windows and Linux: http://leiningen.org/

## Sbt

sbt is packaged for Ubuntu.

Else see http://www.scala-sbt.org/download.html

## buildr

See http://buildr.apache.org/

```gem install --user-install buildr``` for buildr installs buildr into the local .gem folder.

## buck

See facebook.github.io/buck/

Two repositories exist, seem to stay in sync:

* https://github.com/facebook/buck
* https://gerrit.googlesource.com/buck (Beware! 'master' branch was very outdated for me and broken, use branch 'github-master')

git clone, run ant. That yields a working binary that can be put onto PATH (softlinking failed for me).




# Samples

The builds should work for any source tree that follows these conventions:
* Java 7 compliant code
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
$ make clean-builds all --silent
java version "1.7.0_67"
Apache Maven 3.2.5 (NON-CANONICAL_2015-01-25T12:08:31_kruset; 2015-01-25T12:08:31+01:00)
Gradle 2.2.1
sbt launcher version 0.12.4
Buildr 1.4.21
buck version 5a6d5d00d7f3be1329bf501c710ffa409ecea3d8 (Jan 2015)
Leiningen 2.5.1 on Java 1.7.0_76 Java HotSpot(TM) 64-Bit Server VM
Apache Ant(TM) version 1.8.2 compiled on December 3 2011

******* buildr start
cd build/buildr; time buildr -q package
170.12user 2.45system 2:03.98elapsed 139%CPU (0avgtext+0avgdata 5481728maxresident)k
6664inputs+97928outputs (4major+675380minor)pagefaults 0swaps
******* maven start
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
173.33user 2.36system 2:01.85elapsed 144%CPU (0avgtext+0avgdata 4760688maxresident)k
3552inputs+51848outputs (10major+648628minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q jar
179.23user 2.93system 2:08.50elapsed 141%CPU (0avgtext+0avgdata 5312608maxresident)k
1448inputs+54032outputs (0major+702907minor)pagefaults 0swaps
******* buck start
cd build/buck; time buck test
186.03user 2.68system 2:08.45elapsed 146%CPU (0avgtext+0avgdata 5278768maxresident)k
17032inputs+65088outputs (0major+741863minor)pagefaults 0swaps
******* leiningen start
cd build/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'
356.54user 21.34system 8:15.80elapsed 76%CPU (0avgtext+0avgdata 4501808maxresident)k
1920inputs+161168outputs (0major+7177918minor)pagefaults 0swaps
******* ant-ivy start
cd build/ivy; time ant jar -q
375.23user 19.38system 7:42.30elapsed 85%CPU (0avgtext+0avgdata 4842528maxresident)k
912inputs+170776outputs (0major+7396810minor)pagefaults 0swaps
******* sbt start
cd build/sbt; time sbt -java-home /usr/lib/jvm/java-7-oracle/ -q test package
337.19user 2.20system 1:05.40elapsed 518%CPU (0avgtext+0avgdata 5660288maxresident)k
52936inputs+45416outputs (38major+671075minor)pagefaults 0swaps

# second build

$ make all --silent
******* buildr start
cd build/buildr; time buildr -q package
1.18user 0.07system 0:01.26elapsed 99%CPU (0avgtext+0avgdata 146064maxresident)k
0inputs+0outputs (0major+12438minor)pagefaults 0swaps
******* buck start
cd build/buck; time buck test
5.31user 0.27system 0:03.26elapsed 171%CPU (0avgtext+0avgdata 448192maxresident)k
160inputs+288outputs (0major+65587minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q test jar
6.19user 0.27system 0:04.36elapsed 148%CPU (0avgtext+0avgdata 1080240maxresident)k
0inputs+480outputs (0major+79520minor)pagefaults 0swaps
******* maven start
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
169.15user 1.98system 2:00.18elapsed 142%CPU (0avgtext+0avgdata 5212272maxresident)k
0inputs+30952outputs (0major+652705minor)pagefaults 0swaps
******* leiningen start
cd build/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'
325.42user 21.27system 8:05.05elapsed 71%CPU (0avgtext+0avgdata 4382144maxresident)k
624inputs+106976outputs (0major+6905466minor)pagefaults 0swaps
******* ant-ivy start
cd build/ivy; time ant jar -q
347.52user 19.39system 7:32.92elapsed 81%CPU (0avgtext+0avgdata 4840432maxresident)k
0inputs+131544outputs (0major+7203491minor)pagefaults 0swaps
******* sbt start
cd build/sbt; time sbt -java-home /usr/lib/jvm/java-7-oracle/ -q test package
337.19user 2.20system 1:05.40elapsed 518%CPU (0avgtext+0avgdata 5660288maxresident)k
52936inputs+45416outputs (38major+671075minor)pagefaults 0swaps

```

# Observations / FAQ

DISCLAIMER: I am mostly a Maven / Gradle user, so having had least problems with those can also be due to my experience with those.

## What influences performance?

JVM startup adds something like 3 seconds to the whole process. Several tools offer daemons to reduce this offset. Tools not written in JVM languages do not have this offset.

Compiler speed may differ for different compilers. The scala compiler and clojure compiler seemed slower than javac for compiling java sources.

Parallel task execution: On machines with multiple cores, it may be possible to reduce build time by utiliing more than one CPU. However the build-time rarely is reduced by the number of CPUs. The overhead of finding out how to split tasks over several CPUs can eliminate benefits, and often there will be many dependencies that lead to tasks necessarily being build in sequence. Most buildtool will thus mostly offer to only build completely independent sub-modules in parallel. For single-module projects, no additional CPU is used then.
Some tasks may even only work when not run in parallel, so using parallel fatures also increases maintenance effort.

Caching influences incremental builds. Several buildsystems have a simple caching strategy in that they will not run a task if the output still exist. This will improve performance for repeated builds.

Buck was the only build system benchmarked here that offers advanced (true) caching of build results, in that the cache is an independent storage that maintains multiple versions of build results over time. This can dramatically reduce build times in many more situations than simple caching described before.

## Gradle

Gradle was most convenient at testing with junit, it detected itself what was a testcase and what not without relying on the name. The other buildsystems either relied on names (causing both false positives and false negatives), or simply failed with InstantiationException.

To produce fair benchmark results, some test classes had to be removed because they would have punished Gradle for being smarter than the rest, running more tests.

## Sbt

Running junit 4.11 tests with sbt was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

sbt occasionally failed apache commons-math tests, but not consistently so.

## buck

Buck has the most sophisticated caching, that promises extraordinary performance in many common cases (but a bit more convoluted than the simple setup). Buck caches outputs of rules (equivalent to tasks) separate from the build output. It stores multiple versions of outputs, and thus can avoid re-building anything that it has built in the recent past (like over the last week). The cache is by default not removed using ```buck clean```. The cache-key includes several parameters, including the input filetree (filenames and timestamps, not content). Extended options allow sharing the caches between computers, such as the CI servers and developer machines. A single-module project may benefit least from this kind of caching in comparison to the simpler caching strategies of gradle or buildr, so benchmark results for commons-math do not show an large improvement over gradle.

Getting buck to do anything at all was a real pain, ```quickstart``` did not start quickly. There were many details to consider that are settled by convention in other build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase. The official documentation is okay though, but in comparison the other systems were more self-explaining. What is missing from the documentation is an explanation of how to create a nice library jar, the focus seems to be on creating Android APK files. Getting buck to download files from Maven Central or so is possible, but not straightforward. The best approach seems to add "bucklets" from a different git repository and use a specialized rule. It was difficult to adapt buck project files to the traditional folder structure that Maven suggests. This makes it unnecessarily hard to migrate projects from other buildsystems, and it can be expected that projects built with buck will run into problems that have long been solved in the larger community.

buck very few high-level features and plugins compared to gradle and maven, in particular for non-Android projects.

## ant

ant was also difficult to debug (in particular what was missing for junit4).

## leiningen

Leiningen does not have convenient options to run junit tests, in particular filtering out abstract classes by name was difficult. Had to use 3rd party plugin. Also excluding the test files from a jar seemed not trivially possible.

## buildr

buildr (and sbt I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures, until I took care to have a clean system CLASSPATH.

## Why are ant/sbt/leiningen so slow for clean testing of commons-math?

I do not know for sure. There must be some overhead not present in the other systems, maybe a new JVM process is started for each test.

Note that for sbt and leiningen, extra plugins were required to run JUnit tests written in Java. These buildsystems would specialize on tests written in Scala/Clojure, and the results here do not tell whether tests written in Scala or Clojure would have similar overheads.

## So which buildsystem is best?

It depends on what you need.

To choose, consider the following:

- Learning curve
- Maturity
- Performance
- Documentation
- Community size
- IDE support
- Plugin archives, integration with static code analysis, metrics, reports, etc.
- multi language support


## I get InstantiationExceptions with some buildsystem, what is going on?

java.lang.InstantiationException during tests is usually a sign that a TestRunner is trying to run a non-Testcase class (like abstract or util classes). Not all Buildsystems can cope well with that by default.

## cheetah

Originally I wanted to generate Java sources for a benchmark. But generating interesting sources quickly became tedious, so I switched to using commons-math instead. However, I still use my simple classes to debug builds.
Cheetah was not a perfect choice for templating of files, as it makes it hard to control generated filenames.

## Why GNU make?

I chose GNU make for this project because it is omnipresent in linux and very close to shell scripting.

## Why commons-math?

I chose to test against commons-math because it is reasonably large, well tested, and has no dependencies outside the JDK. Other libraries working okay are commons-text, commons-io, commons-imaging, guava.

The main problems I had with commons-math was that the naming for the Testcases is not consistent. the commons-math ant file lists those rules:
```
<include name="**/*Test.java"/> 
<include name="**/*TestBinary.java"/> 
<include name="**/*TestPermutations.java"/> 
<exclude name="**/*AbstractTest.java"/>
```
And even those do not cover all Testcases defined in the codebase.


## Contributions

I welcome anyone who wants to add something.

In particular:

- Simple tweaks for individual buildsystems (they should remain realistic)
- downloading of dependencies to location cached between builds (ant, buck)
- templated configuration of builds (java version, dependencies)
- Parsing the output of time and generating pretty reports / graphs
- sbt using junit 4.12
- Integrate other tools (checkstyle, Findbugs, PMD)
- Integrate other test frameworks (Testng, spock)
- multi-module project setups
- interesting scalable generated sources
- Integrate other languages (groovy, scala, clojure) were possible
- optionally run tests/tasks in parallel using n CPUs
