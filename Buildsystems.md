# Buildsystems overview

I present some observations I made and my opinions here.

DISCLAIMER: I am mostly a Gradle user, so having had least problems with it can also be due to my experience with those.

## ant

<http://ant.apache.org/>

ant is packaged for Ubuntu. Ivy is the dependency management. Ant+Ivy are also used within buck.

Install ivy by placing ivy jar in ant lib dir. See <http://ant.apache.org/ivy/history/latest-milestone/install.html>

ant was difficult to debug (in particular what was missing for junit4).


## Gradle

See <https://gradle.org/>

Gradle was most convenient at testing with junit, it detected itself what was a testcase and what not without relying on the name. The other buildsystems either relied on names (causing both false positives and false negatives), or simply failed with InstantiationException.

To produce fair benchmark results, some test classes had to be removed because they would have punished Gradle for being smarter than the rest, running more tests.

I recommend <http://sdkman.io/> for installing gradle.

## Maven

<http://maven.apache.org>

Maven surprised by recompiling everything on the second run. Some research revealed two long-standing bugs (since 2013) with incremental compilation (MCOMPILER-209, MCOMPILER-205). Even with a workaround, 80 of the 600 classes of commons-math were found stale and recompiled, and hence all tests were also run again. So the benchmark for the second run is not realistic for Maven projects who get lucky enough not to be affected by these bugs. Also see <https://blog.jetbrains.com/teamcity/2012/03/incremental-building-with-maven-and-teamcity/>

Other things about Maven I personally dislike:

Lack of support for accessing root pom folder for shared build configuration:
<http://stackoverflow.com/questions/3084629/finding-the-root-directory-of-a-multi-module-maven-reactor-project>

Transitive dependencies of dependencies with scope "compile" end up also having scope "compile", which causes a huge dependency mess, and there is no way of easily fixing this: <http://stackoverflow.com/questions/11044243/limiting-a-transitive-dependency-to-runtime-scope-in-maven>

To exclude a 2nd level transitive dependency, one first has to exclude the 1st level transitive dependency, then re-include it separately, and then exclude the originally undesired transitive dependency from it.

While maven can build all submodules of a multi-module build with just one command without installing, it cannot build half of them first, then later the other half, unless you install the first half first.

Maven does not allow you to set the working directory of a command, instead you have to switch into that directory, and then invoke maven pointing outward to the directory with the pom.


There is the so called maven enforcer plugin, however it seems that one does not cope with wildcard exclusions, so to use it you need to specify multiple exclusions even if they belong to the same group.

Maven complains about cyclic dependencies when Project B depends on A at runtime scope, and A depends on B at test scope. That's because Maven cannot not separate subproject class compilation and testing.

Some more reasons against Maven: <http://blog.ltgt.net/maven-is-broken-by-design/>

Maven also has many command-line arguments which cannot be specified inside the pom or other configuration files, such as parallel threads, or to print full test failure logs, etc. This means tdevelopers have to always remember which options exist and which they want, which is very inconvenient.

Trying to have separated folders for unit and integration tests also seems like a major headache, since Maven assumes all tests of a module are located in the same source folder. Most workarounds will fail to generate a correct Project model for IDEs like Eclipse. After a lot of googling, one may find a solution with the help of a 3rd party plugin.

Setting up code warnings in Maven:
```http://www.artificialworlds.net/blog/2016/12/23/setting-up-a-sane-maven-project/```

## Sbt

<http://www.scala-sbt.org/download.html>

Running junit 4.11 tests with sbt was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

sbt occasionally failed apache commons-math tests, but not consistently so.

## leiningen

<http://leiningen.org/>

Leiningen does not have convenient options to run junit tests, in particular filtering out abstract classes by name was difficult. Had to use 3rd party plugin. Also excluding the test files from a jar seemed not trivially possible.

Like in the Common LISP ecosystem, Leiningen suffers (or benefits from) a large diversity of projects solving the same problems, leaving it to the user to compare them all and decide which one is best (or least bad).

E.g. Leiningen had no bundled support for subprojects, 3 different plugins libs were available, it was not immediately clear which one is most recommendable.

Also Leiningen had no support for parallel builds / test, but 4 different plugin projects offered this feature.

## buildr

<http://buildr.apache.org/>

buildr is based on ruby and thus uses dependencies uncommon in the java ecosystem. Based on statistics on activity in mailing lists, it seems like the project has lost the interests of its userbase.

buildr (and sbt I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures, until I took care to have a clean system CLASSPATH.

The buildr process was quite fast for small projects, with apparently very little overhead and good parallelization.

## bazel

See <http://bazel.io/>

Bazel caches build results by default in `~/.cache/bazel`, which means that you can delete your local repository, check it out again, and bazel will still find the cached results.

Bazel (Sep 04, 2015) tutorials focus on android, iOS and Google appengine examples, and do not start with simple framework-agnostic examples. The Build file syntax itself is clean, but the way the different BUILD and WORKSPACE files interact with each other is not self-evident or explained in the tutorials. Also the path-like syntax for subprojects and dependencies with colons, double-slashes and '@' symbols ('@junit//jar') looks unusual and complex (it is used similarly for buck and pants). Some examples place BUILD files at the project root and also next to the java source files, which is confusing at a glance but may be a performance optimization. Running bazel spams my project root folder with symlinks to several bazel cache folders, which are kept in `~/.cache/bazel`. My java_library does not just produce a jar, but also a jar_manifest_proto file. Many details of java builds have to be configured, there is none of the convention-over-configuration as provided by Maven or Gradle (canonical file structure like src/main/java/package/Example.class recognized by default). Oddly Bazels java_library rule does look for resource files in the Maven canonical structure. Bazel automatically runs the Google linter "error-prone" on the project and renames java-libraries to lib...jar.

With the 0.2 update, bazel deprecated the Junit runner in favor of the BazelTestRunner, in a backwards incompatibel way, requiring a flag to run the normal Junit runner. Worse, the BazelRunner does not support running more than one test class, so developers either have to write/generate one rule per test, or create test suites just for Bazel.

So basically Bazel imposes the Google standards upon the Bazel users, which is a bit annoying for everyone outside of Google.

Each rule must be named, which imposes an unnecessary burden of creativity and structuredness of the developer. How to best name the rule for a maven dependency? How for a test? Convention over configuration would go a long way here. The rules for names may change, e.g. between 0.1 and 0.2, dashes became forbidden. The name may have hidden implicit meaning, such as hinting at the test class to execute.

The file syntax for the .bazelrc file also has several unconventional features.
Examples online also show some oddities like using java_binary rule with main class "does.not.exist" to get a fatjar, instead of having that as an option in the java_library rule.

I struggled to get the common-math classes and test classes compile and test even with the rule documentation. The documentation of the rules at the time  was insufficient, the tutorials did not cover tests. However, one year later a lot of work seems to have gone into more documentation. 

Bazel uses a database of build results (and input commands) to check whether the inputs of a given tasks have changed, so it does not rely on timestamps of files in the filesystem.
Bazel may be configured to share the caching via hazelcast:
```
* First you need to run a standalone Hazelcast server with JCache API in the
classpath. This will start Hazelcast with the default configuration.
java -cp third_party/hazelcast/hazelcast-3.5.4.jar \
    com.hazelcast.core.server.StartServer
* Then you run Bazel pointing to the Hazelcast server.
bazel build --hazelcast_node=127.0.0.1:5701 --spawn_strategy=remote \
    src/tools/generate_workspace:all
Above command will build generate_workspace with remote spawn strategy that uses
Hazelcast as the distributed caching backend.
```
But I have not tried this out myself.

Bazel 0.1.3 gave confusing caching results when building multiple times, rebuilding one artifact out of 3 when no file had changed.

## buck

See <https://buckbuild.com/>

Buck has sophisticated caching, that promises extraordinary performance in many common cases (but a bit more convoluted than the simple setup). Buck caches outputs of rules (equivalent to tasks) separate from the build output. It stores multiple versions of outputs, and thus can avoid re-building anything that it has built in the recent past (like over the last week). The cache is by default not removed using `buck clean`. The cache-key includes several parameters, including the input filetree (filenames and timestamps, not content). Extended options allow sharing the caches between computers, such as the CI servers and developer machines. A single-module project may benefit least from this kind of caching in comparison to the simpler caching strategies of gradle or buildr, so benchmark results for commons-math do not show an large improvement over gradle.

Getting buck to do anything at all was a real pain, `quickstart` did not start quickly. There were many details to consider that are settled by convention in other build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase. The official documentation is okay though, but in comparison the other systems were more self-explaining. What is missing from the documentation is an explanation of how to create a nice library jar, the focus seems to be on creating Android APK files. Getting buck to download files from Maven Central or so is possible, but not straightforward. The best approach seems to add "bucklets" from a different git repository and use a specialized rule. It was difficult to adapt buck project files to the traditional folder structure that Maven suggests. This makes it unnecessarily hard to migrate projects from other buildsystems, and it can be expected that projects built with buck will run into problems that have long been solved in the larger community.

buck very few high-level features and plugins compared to gradle and maven, in particular for non-Android projects.

buckd left behind many process running in the background. It recommends installing a separate application "watchman" to further optimize caching of build files. watchman itself also seems like a fickle install.


## pants

<https://pantsbuild.github.io/>

I only found pants by coincidence. It originates at Twitter, is written in Python and targets monorepo setups (like bazel and buck). It seems to be used at Twitter and Foursquare, and pretty much nowhere else. To be fair, the version numbers (0.0.63) indicate that the dev team still wants freedom to change the API often. As a consequence, new versions of pants regularly require changes to the build files, backwards compatibility is not a priority it seems.

One consequence of trying to optimize for monorepos in large organizations is to depend on other projects in their source form, not their (released) jar form.

The output from making mistakes in BUILD files was sometimes confusing, sometimes ugly Python stacktraces, sometimes unhelpful Python type error messages:

```bash
    FAILURE
    Exception message: 'str' object has no attribute 'value'
```

or

```bash
IllegalArgumentException: No enum constant org.pantsbuild.tools.jar.JarBuilder.DuplicateAction.CONCAT_TEXT
```

This is a symptom of having not very many active users to report such issues and complain about bad error messages.

Upgrading to a new version of pants suddenly required me to specify a scala compiler version: (<https://github.com/pantsbuild/pants/issues/2534>).

The tutorials were nice and low-level, but missed e.g. explaining the role of file `BUILD.tools`.

The examples online feature a lot of BUILD files (one for each java package), and each contains several library definitions listing individual java classes. That's a lot more effort to write and check than the Maven/Gradle approach. Similarly pants does not seem to allow directory globbing (src/main/**/*.java).

Like Bazel, a lot of responsibility rests on the developer of finding suitable names for rules. A main help at the beginning is to list all rules recursively: `pants list ::` and show all files considered: `pants filedeps :<target>`

Trying to get things to run, I noticed changing a java_library target by adding/removing resources did not invalidate the cache, those changes did not seem to affect the cache key, which is a big surprise to me. Sometimes the error messages suggest inconsistent things, like missing BUILD file when it exists, or missing target when it exists (something else was wrong).

Pants does not cache test results, so building again will run tests again. Pants also left behind several zombie processes when killing with Ctrl-C.

Pants path syntax has special semantics for task names which match the directory name of the file their defined in.

Pants uses an `.INI` file for some configuration (Do you live in the past?). The pants documentation version may lag far behind the latest version.

Pants natively supports shading the tools that it runs, in order to prevent tools (particularly junit/checkstyle/et-al, which do not isolate themselves) from having classpath collisions with the code that they are building. This can take a long time but is very stable, in that it only changes when the version of a tool changes.

Pants uses nailgun in the background, which however failed for me on the Travis CI server.
