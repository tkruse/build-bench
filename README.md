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

See http://facebook.github.io/buck/

Two repositories exist, seem to stay in sync:

* https://github.com/facebook/buck
* https://gerrit.googlesource.com/buck (Beware! 'master' branch was very outdated for me and broken, use branch 'github-master')

git clone, run ant. That yields a working binary that can be put onto PATH (softlinking failed for me).

## bazel

See http://bazel.io/

Installers should be provided (but were not available for me). Installation from source seems easy enough: git clone, run ./compile.sh. Put binary on PATH.

## pants

See https://pantsbuild.github.io/

pants get bonus points for a local, virtualenv based installation. In your project, run:
```
curl -O https://pantsbuild.github.io/setup/pants
chmod +x pants
touch pants.ini
PANT_VERSION=`./pants --version`; echo -e "[DEFAULT]\npants_version: $PANT_VERSION" > pants.ini
```

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
******* sbt start
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



# second build

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
******* maven start
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

# Observations / FAQ

DISCLAIMER: I am mostly a Maven / Gradle user, so having had least problems with those can also be due to my experience with those.

## What influences performance?

JVM startup adds something like 3 seconds to the whole process. Several tools offer daemons to reduce this offset. Tools not written in JVM languages do not have this offset.

Compiler speed may differ for different compilers. The scala compiler and clojure compiler seemed slower than javac for compiling java sources.

Parallel task execution: On machines with multiple cores, it may be possible to reduce build time by utiliing more than one CPU. However the build-time rarely is reduced by the number of CPUs. The overhead of finding out how to split tasks over several CPUs can eliminate benefits, and often there will be many dependencies that lead to tasks necessarily being build in sequence. Most buildtool will thus mostly offer to only build completely independent sub-modules in parallel. For single-module projects, no additional CPU is used then.
Some tasks may even only work when not run in parallel, so using parallel fatures also increases maintenance effort.

Caching influences incremental builds. Several buildsystems have a simple caching strategy in that they will not run a task if the output still exist. This will improve performance for repeated builds.

Buck, Bazel and Pants were the only build system benchmarked here that offers advanced (true) caching of build results, in that the cache is an independent storage that maintains multiple versions of build results over time. This can dramatically reduce build times in many more situations than simple caching described before.

For large projects with plenty of subprojects and subtasks, performance can be gained by caching in a fine-grained way and reusing more previous artifacts. The example and setup used in this benchmark may not be optimal for any given buildsystem. In particular, Pants has some online examples defining plenty of smaller library targets for individual Java files, which might improve caching performance when rebuilding after a single java file changed (not sure what other advantage it could have).

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

## bazel

Bazel (Sep 04, 2015) tutorials focus on android, iOS and Google appengine examples, and do not start with simple Framework agnostic examples. The Build file syntax itself is clean, but the way the different BUILD and WORKSPACE files interact with each other is not self-evident or explained in the tutorials. Also the path-like syntax for subprojects and dependencies with colons, double-slashes and '@' symbols ('@junit//jar') looks unusual and complex. Some examples place BUILD files at the project root and also next to the java source files, which is confusing at a glance. Running bazel spams my project root folder with symlinks to several bazel cache folders, which are kept in ```~/.cache/bazel```. My java_library does not just produce a jar, but also a jar_manifest_proto file. Many details of java builds have to be configured, there is none of the convention-over-configuration as provided by Maven or Gradle (canonical file structure like src/main/java/package/Example.class reconized by default). Oddly Bazels java_library rule does look for resource files in the Maven canonical structure. Bazel automatically runs the Google linter "error-prone" on the project and renames java-libraries to lib...jar.

So basically Bazel imposes the Google standards upon the Bazel users, which is a bit annoying for everyone outside of Google.

Each rule must be named, which imposes an unnecessary burden of creativity and structuredness of the developer. How to best name the rule for a maven dependency? How for a test? Convention over configuration would go a long way here.
The file syntax for the .bazelrc file also has several unconventional features.
Examples online also show some oddities like using java_binary rule with main class "does.not.exist" to get a fatjar, instead of having that as an option in the java_library rule.

I struggled to get the common-math classes and test classes compile and test even with the rule documentation. The documentation of the rules is insufficient, the tutorials do not cover tests.

All of this is a mere matter of improving documentation and maybe a little polishing of the build rules for the general public outside Google.

## pants

I only found pants by coincidence. It originates at Twitter, is written in Python and targets monorepo setups (like bazel and buck).

One consequence of trying to optimize for monorepos in large organizations is to depend on other projects in their source form, not their (released) jar form.

The output from making mistakes in BUILD files was sometimes confusing, sometimes ugly Python stacktraces, sometimes unhelpful Python type error messages:
```
               FAILURE
Exception message: 'str' object has no attribute 'value'
```

The tutorials were nice and low-level, but missed e.g. explaining the role of file ```BUILD.tools```.

The examples online feature a lot of BUILD files (one for each java package), and each contains several library definitions listing individual java classes. That's a lot more effort to write and check than the Maven/Gradle approach. Similarly pants does not seem to allow directoy globbing (src/main/**/*.java).

Like Bazel, a lot of responsibility rests on the developer of finding suitable names for rules. A main help at the beginning is to list all rules recursively: ```pants list ::``` and show all files consdered: ```pants filedeps :<target>```

Trying to get things to run, I noticed changing a java_library target by adding/removing resources did not invalidate the cache, those changes did not seem to affect the cache key, which is a big surprise to me. Sometimes the error messages suggest inconsistent things, like missing BUILD file when it exists, or missing target when it exists (something else was wrong).

Pants path syntax has special semantics for task names which match the directory name of the file their defined in.

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
- Integrate other languages (groovy, scala, clojure) where possible
- optionally run tests/tasks in parallel using n CPUs
