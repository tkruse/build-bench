# Buildsystems overview

I present some observations I made and my opinions here.

DISCLAIMER: I am mostly a Gradle user, so having had least problems with it can also be due to my experience with those.

## Gradle

See <https://gradle.org/>

Gradle was most convenient at testing with junit, it detected itself what was a testcase and what not without relying on the name. The other buildsystems either relied on names (causing both false positives and false negatives), or simply failed with InstantiationException.

To produce fair benchmark results, some test classes had to be removed because they would have punished Gradle for being smarter than the rest, running more tests.

I recommend <http://sdkman.io/> for installing gradle.

## Maven

<http://maven.apache.org>

Maven surprised by recompiling everything on the second run. Some research revealed two long-standing bugs (since 2013) with incremental compilation (MCOMPILER-209, MCOMPILER-205). Even with a workaround, 80 of the 600 classes of commons-math were found stale and recompiled, and hence all tests were also run again. So the benchmark for the second run is not realistic for Maven projects who get lucky enough not to be affected by these bugs.

Other things about Maven I personally dislike:

Lack of support for accessing root pom folder for shared build configuration:
<http://stackoverflow.com/questions/3084629/finding-the-root-directory-of-a-multi-module-maven-reactor-project>

Transitive dependencies of dependencies with scope "compile" end up also having scope "compile", which causes a huge dependency mess, and there is no way of easily fixing this: <http://stackoverflow.com/questions/11044243/limiting-a-transitive-dependency-to-runtime-scope-in-maven>

There is the so called maven enforcer plugin, however it seems that one does not cope with wildcard exclusions, so to use it you need to exclude every single transitive dependency by hand, then redeclare it as runtime dependency.

Maven complains about cyclic dependencies when Probejct B depends on A at runtime scope, and A depends on B at test scope. That's because Maven cannot not separate subproject class compilation and testing.

Reusing the test resources from one submodule in another submodule seems impossible.

Some more reasons against Maven: <http://blog.ltgt.net/maven-is-broken-by-design/>

## Sbt

<http://www.scala-sbt.org/download.html>

Running junit 4.11 tests with sbt was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

sbt occasionally failed apache commons-math tests, but not consistently so.

## buck

See <https://buckbuild.com/>

Buck has the most sophisticated caching, that promises extraordinary performance in many common cases (but a bit more convoluted than the simple setup). Buck caches outputs of rules (equivalent to tasks) separate from the build output. It stores multiple versions of outputs, and thus can avoid re-building anything that it has built in the recent past (like over the last week). The cache is by default not removed using `buck clean`. The cache-key includes several parameters, including the input filetree (filenames and timestamps, not content). Extended options allow sharing the caches between computers, such as the CI servers and developer machines. A single-module project may benefit least from this kind of caching in comparison to the simpler caching strategies of gradle or buildr, so benchmark results for commons-math do not show an large improvement over gradle.

Getting buck to do anything at all was a real pain, `quickstart` did not start quickly. There were many details to consider that are settled by convention in other build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase. The official documentation is okay though, but in comparison the other systems were more self-explaining. What is missing from the documentation is an explanation of how to create a nice library jar, the focus seems to be on creating Android APK files. Getting buck to download files from Maven Central or so is possible, but not straightforward. The best approach seems to add "bucklets" from a different git repository and use a specialized rule. It was difficult to adapt buck project files to the traditional folder structure that Maven suggests. This makes it unnecessarily hard to migrate projects from other buildsystems, and it can be expected that projects built with buck will run into problems that have long been solved in the larger community.

buck very few high-level features and plugins compared to gradle and maven, in particular for non-Android projects.

buckd left behind many process running in the background.

## ant

<http://ant.apache.org/>

ant is packaged for Ubuntu. Ivy is the dependency management. Ant+Ivy are also used within buck.

Install ivy by placing ivy jar in ant lib dir. See <http://ant.apache.org/ivy/history/latest-milestone/install.html>

ant was difficult to debug (in particular what was missing for junit4).

## leiningen

<http://leiningen.org/>

Leiningen does not have convenient options to run junit tests, in particular filtering out abstract classes by name was difficult. Had to use 3rd party plugin. Also excluding the test files from a jar seemed not trivially possible.

Leiningen had no bundled support for subprojects, 3 different plugins libs were available, it was not immediately clear which one is most recommendable.

## buildr

<http://buildr.apache.org/>

buildr (and sbt I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures, until I took care to have a clean system CLASSPATH.

The buildr process was quite fast for small projects, with apparently very little overhead and good parallelization.

## bazel

See <http://bazel.io/>

Bazel caches build results by default in `~/.cache/bazel`, which means that you can delete your local repository, check it out again, and bazel will still find the cached results.

Bazel (Sep 04, 2015) tutorials focus on android, iOS and Google appengine examples, and do not start with simple Framework agnostic examples. The Build file syntax itself is clean, but the way the different BUILD and WORKSPACE files interact with each other is not self-evident or explained in the tutorials. Also the path-like syntax for subprojects and dependencies with colons, double-slashes and '@' symbols ('@junit//jar') looks unusual and complex. Some examples place BUILD files at the project root and also next to the java source files, which is confusing at a glance. Running bazel spams my project root folder with symlinks to several bazel cache folders, which are kept in `~/.cache/bazel`. My java_library does not just produce a jar, but also a jar_manifest_proto file. Many details of java builds have to be configured, there is none of the convention-over-configuration as provided by Maven or Gradle (canonical file structure like src/main/java/package/Example.class recognized by default). Oddly Bazels java_library rule does look for resource files in the Maven canonical structure. Bazel automatically runs the Google linter "error-prone" on the project and renames java-libraries to lib...jar.

So basically Bazel imposes the Google standards upon the Bazel users, which is a bit annoying for everyone outside of Google.

Each rule must be named, which imposes an unnecessary burden of creativity and structuredness of the developer. How to best name the rule for a maven dependency? How for a test? Convention over configuration would go a long way here.
The file syntax for the .bazelrc file also has several unconventional features.
Examples online also show some oddities like using java_binary rule with main class "does.not.exist" to get a fatjar, instead of having that as an option in the java_library rule.

I struggled to get the common-math classes and test classes compile and test even with the rule documentation. The documentation of the rules is insufficient, the tutorials do not cover tests.

All of this is a mere matter of improving documentation and maybe a little polishing of the build rules for the general public outside Google.

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
