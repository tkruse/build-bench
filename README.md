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
Generating 500 java source files
Generating 500 java test source files
******* buildr start
(in /home/kruset/work/java/build-bench/build/buildr, development)
8.09user 0.35system 0:05.62elapsed 150%CPU (0avgtext+0avgdata 580224maxresident)k
464inputs+24624outputs (0major+85505minor)pagefaults 0swaps
******* maven start
216.26user 17.33system 2:47.79elapsed 139%CPU (0avgtext+0avgdata 752272maxresident)k
40inputs+68904outputs (0major+5140785minor)pagefaults 0swaps
******* sbt start
27.68user 0.62system 0:13.07elapsed 216%CPU (0avgtext+0avgdata 2526208maxresident)k
1480inputs+12448outputs (0major+257403minor)pagefaults 0swaps
******* gradle start
5.76user 0.20system 0:04.20elapsed 141%CPU (0avgtext+0avgdata 801536maxresident)k
568inputs+5360outputs (0major+68575minor)pagefaults 0swaps
```

## Comments

Note that I am not sure whether the sample code is useful for a benchmark,
nor have the buildsystem parameters been adapted for maximum speed.

Contributions welcome.
