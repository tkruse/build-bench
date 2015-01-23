# build-bench

Benchmarks for different Java buildsystems.
A number of source files is generated, and then compiled, tested and jarred.

Manual installation of different buildsystems is required.
Still looking at how to best create a nice summary of versions used andresults.


# Prerequisites:

* bash
* make
* cheetah
* maven
* gradle
* sbt
* buildr
* leiningen (no junit tests)

Installing some of those can be a pain. I recommend ```gvm``` for gradle, and ```gem install --user-install buildr``` for buildr.

Cheetah was not a perfect choice for templating of files, as it makes it hard to control generated filenames.

Running junit 4.11 tests with scala was a pain, because getting junit 4.x to work was not trivial, required 3rd party testing libs in specific versions.

Getting buck to do anything was a real pain, so many details to consider that are settled by convention inother build tools. Most failures had no helpful error messages. Making buck run existing tests was painful because buck will try to run any class it finds as a testcase, and fail if it is not (TestUtils, abstract test classes), and does not provide any help in filtering what shall be considered a TestCase.

Leiningen does not have any easy option to run junit tests, so it's benchmark results are not to be compared.


buildr (and scala I think) used the current CLASSPATH when running tests (instead of an isolated classpath). That caused surprising test failures.

java.lang.InstantiationException during tests is usually a sign that a TestRnner is trying to run a non-Testcase class (like abstract or util classes).

sbt did not terminate when running commons-math tests.


## Running
```
$ make clean all --silent
```


Sample output for a clean build (manually cleaned up):
```
$ make clean all --silent
java version "1.7.0_67"
Apache Maven 3.0.5 (r01de14724cdef164cd33c7c8c2fe155faf9602da; 2013-02-19 14:51:28+0100)
Gradle 2.2.1
sbt launcher version 0.12.4
Buildr 1.4.21
buck --version
buck version 5a6d5d00d7f3be1329bf501c710ffa409ecea3d8
Leiningen 2.5.1 on Java 1.7.0_76 Java HotSpot(TM) 64-Bit Server VM

******* buck start
cd build/buck; time buck test
197.42user 2.67system 2:25.22elapsed 137%CPU (0avgtext+0avgdata 5406912maxresident)k
49712inputs+82240outputs (86major+930522minor)pagefaults 0swaps
******* maven start
cd build/maven; time mvn -q package -Dsurefire.printSummary=false
189.12user 2.72system 2:44.49elapsed 116%CPU (0avgtext+0avgdata 5406704maxresident)k
29504inputs+65144outputs (17major+708316minor)pagefaults 0swaps
******* buildr start
cd build/buildr; time buildr -q package
261.03user 3.24system 4:04.94elapsed 107%CPU (0avgtext+0avgdata 5538144maxresident)k
15144inputs+122240outputs (22major+751402minor)pagefaults 0swaps
******* gradle start
cd build/gradle; time gradle -q jar
285.26user 3.62system 4:22.05elapsed 110%CPU (0avgtext+0avgdata 5394032maxresident)k
1584inputs+71752outputs (0major+845596minor)pagefaults 0swaps
```

## Comments

Note that I am not sure whether the sample code is useful for a benchmark,
nor have the buildsystem parameters been adapted for maximum speed.

Contributions welcome.
