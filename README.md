# build-bench

Benchmark setup for Java buildsystems.

While Maven and Gradle are used by most Java projects in the wild, there are many alternatives to choose from. Comparing those is difficult. This project is a setup to run a buildprocess for java projects using multiple buildsystems.
It can serve to benchmark buildsystems, or just to compare features.

The project works mostly well using Apache commons-math as sample source. However, benchmarking of special features like bucks caching would benefit more from a multi-module setup.

Manual installation of the different buildsystems is required.

The project is driven using GNU make. The ```Makefile``` creates a ```build``` folder,
containing a folder structure for benchmarks. Subfolders follow the pattern ```<benchmarkname>/<buildsystemname>```. Into those folders, Java source files and buildsystem specific files will be copied / generated. Then t eh buildsystem is invoked inside that folder and the time until completion is measured.

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

Custom configurations are loaded after the ```defaults.mk``` providing some convention over configuration.

# Prerequisites

* Java        (7 or 8, configure JAVA_HOME)
* bash        (the standard Ubuntu shell)
* GNU make    (should be present on any *nix)
* Python      (2 or 3)
* jinja2      (if using templated sources, install via pip or apt-get)
* Ruby        (for Apache buildr, jruby should also work)

# Buildsystems

## Apache ant + ivy

ant is packaged for Ubuntu.
For more recent version see: http://ant.apache.org/manual/install.html

Install ivy by placing ivy jar in ant lib dir. See http://ant.apache.org/ivy/history/latest-milestone/install.html

## Apache Maven

Installing a 3.x version should be easy, it is packaged for Ubuntu.
E.g.

$ sudo apt-get install maven3

More recent versions can be found at: http://maven.apache.org/download.cgi

## Gradle

See https://gradle.org/

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

See https://buckbuild.com/

Two repositories exist, seem to stay in sync:

* https://github.com/facebook/buck
* https://gerrit.googlesource.com/buck (Beware! 'master' branch was very outdated for me and broken, use branch 'github-master')

git clone, run ant. That yields a working binary that can be put onto PATH (softlinking failed for me).


## bazel

See http://bazel.io/

Use the downloadable installer with the ```--user option```. Then put the ~/.baze/bin folder onto your ```PATH```.

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

# Observations / FAQ

DISCLAIMER: I am mostly a Maven / Gradle user, so having had least problems with those can also be due to my experience with those.

## What influences performance?

JVM startup adds something like 3 seconds to the whole process. Several tools offer daemons to reduce this offset. Tools not written in JVM languages do not have this offset.

Parallel task execution: On machines with multiple cores, it may be possible to reduce build time by utiliing more than one CPU. However the build-time rarely is reduced by the number of CPUs. The overhead of finding out how to split tasks over several CPUs can eliminate benefits, and often there will be many dependencies that lead to tasks necessarily being build in sequence. Most buildtool will thus mostly offer to only build completely independent sub-modules in parallel. For single-module projects, no additional CPU is used then.
Some tasks may even only work when not run in parallel, so using parallel fatures also increases maintenance effort.

Compiler speed may differ for different compilers. The scala compiler and clojure compiler seemed slower than javac for compiling java sources.

Incremental re-compilation, meaning compiling only files that are affected by a change, can drastically reduce build times.

Incremental build steps beond compilation help (e.g. Maven can compile incrementally, but not test incrementally).

Caching influences incremental builds. Several buildsystems have a simple caching strategy in that they will not run a task if the output still exist. This will improve performance for repeated builds.

Buck, Bazel and Pants were the only build system benchmarked here that offers advanced (true) caching of build results, in that the cache is an independent storage that maintains multiple versions of build results over time. This can dramatically reduce build times in many more situations than simple caching described before.

For large projects with plenty of subprojects and subtasks, performance can be gained by caching in a fine-grained way and reusing more previous artifacts. The example and setup used in this benchmark may not be optimal for any given buildsystem. In particular, Pants has some online examples defining plenty of smaller library targets for individual Java files, which might improve caching performance when rebuilding after a single java file changed (not sure what other advantage it could have).

## So which buildsystem should I use for Java projects?

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

## No really, which one should I use for Java projects?

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

## Gradle

Gradle was most convenient at testing with junit, it detected itself what was a testcase and what not without relying on the name. The other buildsystems either relied on names (causing both false positives and false negatives), or simply failed with InstantiationException.

To produce fair benchmark results, some test classes had to be removed because they would have punished Gradle for being smarter than the rest, running more tests.

## Maven

Maven surprised by recompiling everything on the second run. Some research revealed two long-standing bugs (since 2013) with incremental compilation (MCOMPILER-209, MCOMPILER-205). Even with a workaround, 80 of the 600 classes of commons-math were found stale and recompiled, and hence all tests were also run again. So the benchmark for the second run is not realistic for Maven projects who get lucky enough not to be affected by these bugs.

Other things about Maven I personally dislike:

Lack of support for accessing root pom folder for shared build configuration:
http://stackoverflow.com/questions/3084629/finding-the-root-directory-of-a-multi-module-maven-reactor-project

Transitive dependencies of dependencies with scope "compile" end up also having scope "compile", which causes a huge dependency mess, and there is no way of easily fixing this: http://stackoverflow.com/questions/11044243/limiting-a-transitive-dependency-to-runtime-scope-in-maven

There is the so called maven enforcer plugin, however it seems that one does not cope with wildcard exclusions, so to use it you need to exclude every single transitive dependency by hand, then redeclare it as runtime dependency.

Maven complains about cyclic dependencies when Probejct B depends on A at runtime scope, and A depends on B at test scope. That's because Maven cannot not separate subproject class compilation and testing.

Reusing the test resources from one submodule in another submodule seems impossible.

Some more reasons against Maven: http://blog.ltgt.net/maven-is-broken-by-design/

## Sbt

Running junit 4.11 tests with sbt was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

sbt occasionally failed apache commons-math tests, but not consistently so.

## buck

Buck has the most sophisticated caching, that promises extraordinary performance in many common cases (but a bit more convoluted than the simple setup). Buck caches outputs of rules (equivalent to tasks) separate from the build output. It stores multiple versions of outputs, and thus can avoid re-building anything that it has built in the recent past (like over the last week). The cache is by default not removed using ```buck clean```. The cache-key includes several parameters, including the input filetree (filenames and timestamps, not content). Extended options allow sharing the caches between computers, such as the CI servers and developer machines. A single-module project may benefit least from this kind of caching in comparison to the simpler caching strategies of gradle or buildr, so benchmark results for commons-math do not show an large improvement over gradle.

Getting buck to do anything at all was a real pain, ```quickstart``` did not start quickly. There were many details to consider that are settled by convention in other build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase. The official documentation is okay though, but in comparison the other systems were more self-explaining. What is missing from the documentation is an explanation of how to create a nice library jar, the focus seems to be on creating Android APK files. Getting buck to download files from Maven Central or so is possible, but not straightforward. The best approach seems to add "bucklets" from a different git repository and use a specialized rule. It was difficult to adapt buck project files to the traditional folder structure that Maven suggests. This makes it unnecessarily hard to migrate projects from other buildsystems, and it can be expected that projects built with buck will run into problems that have long been solved in the larger community.

buck very few high-level features and plugins compared to gradle and maven, in particular for non-Android projects.

buckd left behind many process running in the background.

## ant

ant was also difficult to debug (in particular what was missing for junit4).

## leiningen

Leiningen does not have convenient options to run junit tests, in particular filtering out abstract classes by name was difficult. Had to use 3rd party plugin. Also excluding the test files from a jar seemed not trivially possible.

Leiningen had no bundled support for subprojects, 3 different plugins libs were available, it was not immediately clear which one is most recommendable.

## buildr

buildr (and sbt I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures, until I took care to have a clean system CLASSPATH.

The buildr process was quite fast for small projects, with apparently very little overhead and good parallelization.

## bazel

Bazel (Sep 04, 2015) tutorials focus on android, iOS and Google appengine examples, and do not start with simple Framework agnostic examples. The Build file syntax itself is clean, but the way the different BUILD and WORKSPACE files interact with each other is not self-evident or explained in the tutorials. Also the path-like syntax for subprojects and dependencies with colons, double-slashes and '@' symbols ('@junit//jar') looks unusual and complex. Some examples place BUILD files at the project root and also next to the java source files, which is confusing at a glance. Running bazel spams my project root folder with symlinks to several bazel cache folders, which are kept in ```~/.cache/bazel```. My java_library does not just produce a jar, but also a jar_manifest_proto file. Many details of java builds have to be configured, there is none of the convention-over-configuration as provided by Maven or Gradle (canonical file structure like src/main/java/package/Example.class recognized by default). Oddly Bazels java_library rule does look for resource files in the Maven canonical structure. Bazel automatically runs the Google linter "error-prone" on the project and renames java-libraries to lib...jar.

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

The examples online feature a lot of BUILD files (one for each java package), and each contains several library definitions listing individual java classes. That's a lot more effort to write and check than the Maven/Gradle approach. Similarly pants does not seem to allow directory globbing (src/main/**/*.java).

Like Bazel, a lot of responsibility rests on the developer of finding suitable names for rules. A main help at the beginning is to list all rules recursively: ```pants list ::``` and show all files considered: ```pants filedeps :<target>```

Trying to get things to run, I noticed changing a java_library target by adding/removing resources did not invalidate the cache, those changes did not seem to affect the cache key, which is a big surprise to me. Sometimes the error messages suggest inconsistent things, like missing BUILD file when it exists, or missing target when it exists (something else was wrong).

Pants does not cache test results, so building again will run tests again. Pants also left behind several zombie processes when killing with Ctrl-C.

Pants path syntax has special semantics for task names which match the directory name of the file their defined in.

## Why are ant/sbt/leiningen so slow for clean testing of commons-math?

I do not know for sure. There must be some overhead not present in the other systems, maybe a new JVM process is started for each test.

Note that for sbt and leiningen, extra plugins were required to run JUnit tests written in Java. These buildsystems would specialize on tests written in Scala/Clojure, and the results here do not tell whether tests written in Scala or Clojure would have similar overheads.


## I get InstantiationExceptions with some buildsystem, what is going on?

java.lang.InstantiationException during tests is usually a sign that a TestRunner is trying to run a non-Testcase class (like abstract or util classes). Not all Buildsystems can cope well with that by default.

## Why GNU make?

I chose GNU make for this project because it is omnipresent in linux and very close to shell scripting.

## Why jinja2?

I needed some templating engine, and scripting in Python seemed the least effort. Jinja2 is popular and een around for a while. Mako and Genshi also seemed nice at a glance.

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
