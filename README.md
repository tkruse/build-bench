# build-bench

Benchmarks for different buildsystems for Java. This can also be used as a kind or Rosetta stone for buildsystem setups.

Manual installation of different buildsystems is required.
Still looking at how to best create a nice summary of versions used and results.

Do not interpret the test results unless you understand well how they were produced. I make no claim (yet) that if in any test one system ends before another, that systemis generally faster than the other.

# Prerequisites

* bash
* make
* cheetah

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

sbt is package for Ubuntu.
Else Ssee http://www.scala-sbt.org/download.html

## buildr

```gem install --user-install buildr``` for buildr installs buildr into the local .gem folder.

## buck

Two repositories exist, seem to stay in sync:

* https://github.com/facebook/buck
* https://gerrit.googlesource.com/buck (Beware! 'master' branch was very outdated for me and broken, use branch 'github-master')

git clone, run ant, that yi            elds a working binray that can be put onto PATH (softlinking failed for me).


## Running
```
$ make clean all --silent
```

## Features

The makefile creates a ```build``` folder, with a ```src``` folder, which is expected to contain sources in the canonical layout (```src/main/java``` etc.)
Then it creates project setups for each buildsystem inside
```build/<buildsystemname>``` with a softlink to ```src```.
Then it invokes the build command to compile, unit-test and jar the sources.

# Samples

The builds should work for any source tree that follows these conventions (Canonical Maven/Gradle/sbt/clojure):
* Java 7 compliant code
* Java sources in src/main/java
* Test sources in src/test/java
* Other resources in src/test/resources
* Tests written in Junit4 compatible fashion
* Test classes named *Test.java
* Abstract Test parent classes named *AbstractTest.java (to be excluded, some buildsystems fail else)


## Output

Sample output (manually cleaned up) for a clean build of apache commons.math (compile + test):
```
$ make clean all --silent
java version "1.7.0_67"
Apache Maven 3.0.5 (r01de14724cdef164cd33c7c8c2fe155faf9602da; 2013-02-19 14:51:28+0100)
Gradle 2.2.1
sbt launcher version 0.12.4
Buildr 1.4.21
buck version 5a6d5d00d7f3be1329bf501c710ffa409ecea3d8 (Jan 2015)
Leiningen 2.5.1 on Java 1.7.0_76 Java HotSpot(TM) 64-Bit Server VM
Apache Ant(TM) version 1.8.2 compiled on December 3 2011

******* maven start
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
189.12user 2.72system 2:44.49elapsed 116%CPU (0avgtext+0avgdata 5406704maxresident)k
29504inputs+65144outputs (17major+708316minor)pagefaults 0swaps
******* buck start
cd build/buck; time buck test
197.42user 2.67system 2:25.22elapsed 137%CPU (0avgtext+0avgdata 5406912maxresident)k
49712inputs+82240outputs (86major+930522minor)pagefaults 0swaps
******* buildr start
cd build/buildr; time buildr -q package
261.03user 3.24system 4:04.94elapsed 107%CPU (0avgtext+0avgdata 5538144maxresident)k
15144inputs+122240outputs (22major+751402minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q jar
285.26user 3.62system 4:22.05elapsed 110%CPU (0avgtext+0avgdata 5394032maxresident)k
1584inputs+71752outputs (0major+845596minor)pagefaults 0swaps
******* ant-ivy start
cd build/ivy; time ant jar -q
463.78user 21.06system 8:59.52elapsed 89%CPU (0avgtext+0avgdata 4843280maxresident)k
1672inputs+194360outputs (0major+7661187minor)pagefaults 0swaps
```

# Comments

Note that I am not sure whether the sample code is useful for a benchmark,
nor have the buildsystem parameters been adapted for maximum speed.

Contributions welcome.

## Observations

Cheetah was not a perfect choice for templating of files, as it makes it hard to control generated filenames.

Running junit 4.11 tests with scala was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

Getting buck to do anything at all was a real pain, ```quickstart``` did not start quickly. There were many details to consider that are settled by convention inother build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase. The official documentation is okay though, but in comparison the other systems were more self-explaining.

ant was also difficult to debug (in particular what was missing for junit4).

Leiningen does not have convenient options to run junit tests, in particular filtering out abstract classes by name was difficult. Also excluding the test files from a jar seemed not trivially possible.

buildr (and scala I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures, until I took care to have a clean system CLASSPATH.

java.lang.InstantiationException during tests is usually a sign that a TestRunner is trying to run a non-Testcase class (like abstract or util classes).

sbt did not terminate when running certain apache commons-math tests.
