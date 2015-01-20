# build-bench

Benchmarks for different Java buildystems.
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

Installing some of those can be a pain. I recommend ```gvm``` for gradle, and ```gem install --user-install buildr``` for buildr.

Cheetah was not a perfect choice for templating of files, as it makes it hard to control generated filenames.

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

Note that I am not sure whether the sample code is useful for a benchmark,
nor have the buildsystem parameters been adapted for maximum speed.

I hope to also add Leiningen, ant+Ivy and buck, and measure speed for incremental builds.

Contributions welcome.
