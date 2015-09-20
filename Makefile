# only works when running make in root folder :-(
ROOT_DIR=$(shell pwd)
BUILD_DIR=build
RESULTS_DIR=$(BUILD_DIR)/results

SOURCE_PROJECT=commons-math
# SOURCE_PROJECT=simple

# Folder with structures for running buildsystems
BUILD_DEFINITIONS=singleModule
# folder containing source resources except for buildfiles
DOWNLOAD_SOURCES_DIR=buildsrc

TEMPLATES_DIR=templates
FILE_NUM=5
JAVA_HOME=/usr/lib/jvm/java-7-oracle/

.PHONY: default
default: all

.PHONY: clean-all
clean-all:
	rm -rf build buildsrc

.PHONY: clean-builds
clean-builds:
	rm -rf build

# Delete buildsystems from list you do not wish to test
.PHONY: all
all: \
gradle \
maven \
buildr \
ant_ivy \
buck \
leiningen \
sbt \
bazel \
pants \


.PHONY: versions
versions:
	java -version
	mvn --version
	gradle --version
	sbt sbtVersion
	buildr --version
	buck --version
	ant -version
	bazel version
	cd $(BUILD_DEFINITIONS)/pants; pants --version

## pants
# Assuming pants is globally installed, even though
# typically pants may be a local executable

.PHONY: pants
pants: $(BUILD_DIR)/pants/src $(BUILD_DIR)/pants/BUILD
	$(info ******* pants start)
	cd $(BUILD_DIR)/pants; time pants test :test -q

$(BUILD_DIR)/pants/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/pants
	@cd $(BUILD_DIR)/pants; cp -rf ../src .

$(BUILD_DIR)/pants/BUILD: $(BUILD_DIR)/src
	@cp -rf $(BUILD_DEFINITIONS)/pants $(BUILD_DIR)

## bazel

.PHONY: bazel
bazel: $(BUILD_DIR)/bazel/src $(BUILD_DIR)/bazel/BUILD
	$(info ******* bazel start)
	cd $(BUILD_DIR)/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests

$(BUILD_DIR)/bazel/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/bazel
	@cd $(BUILD_DIR)/bazel; ln -s ../src

$(BUILD_DIR)/bazel/BUILD: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/bazel $(BUILD_DIR)

## maven

.PHONY: maven
maven: $(BUILD_DIR)/maven/src $(BUILD_DIR)/maven/pom.xml
	$(info ******* maven start)
	cd $(BUILD_DIR)/maven; time mvn -q package -Dsurefire.printSummary=false

$(BUILD_DIR)/maven/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/maven
	@cd $(BUILD_DIR)/maven; ln -s ../src

$(BUILD_DIR)/maven/pom.xml: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/maven $(BUILD_DIR)

## gradle

.PHONY: gradle
gradle: $(BUILD_DIR)/gradle/src $(BUILD_DIR)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(BUILD_DIR)/gradle; time gradle -q test jar

$(BUILD_DIR)/gradle/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/gradle
	@cd $(BUILD_DIR)/gradle; ln -s ../src

$(BUILD_DIR)/gradle/build.gradle: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/gradle $(BUILD_DIR)

## sbt

.PHONY: sbt
sbt: $(BUILD_DIR)/sbt/src $(BUILD_DIR)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(BUILD_DIR)/sbt; time sbt -java-home $(JAVA_HOME) test package

$(BUILD_DIR)/sbt/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/sbt
	@cd $(BUILD_DIR)/sbt; ln -s ../src

$(BUILD_DIR)/sbt/build.sbt: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/sbt $(BUILD_DIR)

## buildr

.PHONY: buildr
buildr: $(BUILD_DIR)/buildr/src $(BUILD_DIR)/buildr/buildfile
	$(info ******* buildr start)
	cd $(BUILD_DIR)/buildr; time buildr -q package

$(BUILD_DIR)/buildr/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/buildr
	@cd $(BUILD_DIR)/buildr; ln -s ../src

$(BUILD_DIR)/buildr/buildfile: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/buildr $(BUILD_DIR)

## Leiningen

.PHONY: leiningen
leiningen: $(BUILD_DIR)/leiningen/src $(BUILD_DIR)/leiningen/project.clj
	$(info ******* leiningen start)
# need hack to run both tests and jar? Using plugin to run junit tests
	cd $(BUILD_DIR)/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'

$(BUILD_DIR)/leiningen/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/leiningen
	@cd $(BUILD_DIR)/leiningen; ln -s ../src

$(BUILD_DIR)/leiningen/project.clj: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/leiningen $(BUILD_DIR)

## buck

.PHONY: buck
buck: $(BUILD_DIR)/buck/src $(BUILD_DIR)/buck/BUCK
	$(info ******* buck start)
	cd $(BUILD_DIR)/buck; time buck fetch //:junit
	cd $(BUILD_DIR)/buck; time buck fetch //:hamcrest-core
	cd $(BUILD_DIR)/buck; time buck test

$(BUILD_DIR)/buck/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/buck
	@cd $(BUILD_DIR)/buck; ln -s ../src

$(BUILD_DIR)/buck/BUCK: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/buck $(BUILD_DIR)

## ant_ivy

.PHONY: ant_ivy
ant_ivy: $(BUILD_DIR)/ivy/src $(BUILD_DIR)/ivy/build.xml
	$(info ******* ant-ivy start)
	cd $(BUILD_DIR)/ivy; time ant jar -q

$(BUILD_DIR)/ivy/src: $(BUILD_DIR)/src
	@mkdir -p $(BUILD_DIR)/ivy
	@cd $(BUILD_DIR)/ivy; ln -s ../src

$(BUILD_DIR)/ivy/build.xml: $(BUILD_DIR)/src
	@cp -r $(BUILD_DEFINITIONS)/ivy $(BUILD_DIR)



#
# Different sources to be used for benchmark
#


$(BUILD_DIR)/src: $(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)/src
	@mkdir -p $(BUILD_DIR)
# softlinking causes problems with some tools
	@cd $(BUILD_DIR); cp -r ../$(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)/src .

$(DOWNLOAD_SOURCES_DIR)/commons-math/src:
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)
	cd $(DOWNLOAD_SOURCES_DIR); git clone https://git-wip-us.apache.org/repos/asf/commons-math.git; cd commons-math; git checkout MATH_3_4
# Sadly this test fails with buck because java.io.File cannot handle uris inside jars.
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/random/EmpiricalDistributionTest.java
# Some actual Tests sadly do not end with Test.java, so for fairness sake they cannot be used
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/fitting/leastsquares/EvaluationTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestBinary.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestPermutations.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/optim/nonlinear/vector/jacobian/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/optimization/general/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/util/FastMathTestPerformance.java


$(DOWNLOAD_SOURCES_DIR)/simple/src:
	$(info Generating $(FILE_NUM) java source files)
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)/simple/src/main/java/com
	@for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/simple/src/main --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/simple/src/main/java/com/Simple$$number.java ; \
	done
	$(info Generating $(FILE_NUM) java test source files)
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)/simple/src/test/java/com
	@for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/simple/src/test --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/simple/src/test/java/com/Simple"$$number"Test.java ; \
	done
