# only works when running make in root folder :-(
ROOT_DIR=$(shell pwd)
BUILD_DIR=build
RESULTS_DIR=$(BUILD_DIR)/results

# templates/sources for buildsystems and project sources


# BUILD_DEFINITIONS=multiModule
# SOURCE_PROJECT=multi


BUILD_DEFINITIONS=singleModule
SOURCE_PROJECT=commons-math
# SOURCE_PROJECT=simple


# folder containing source resources except for buildfiles
DOWNLOAD_SOURCES_DIR=buildsrc

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
	/java -version
	mvn --version
	gradle --version
	sbt sbtVersion
	buildr --version
	buck --version
	ant -version
	bazel version
	cd templates/buildsystems/$(BUILD_DEFINITIONS)/pants; pants --version

## pants
# Assuming pants is globally installed, even though
# typically pants may be a local executable

.PHONY: pants
pants: $(BUILD_DIR)/pants/src $(BUILD_DIR)/pants/BUILD
	$(info ******* pants start)
	cd $(BUILD_DIR)/pants; time pants test :test -q

$(BUILD_DIR)/pants/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/pants
# softlinking causes issues
	@cd $(BUILD_DIR)/pants; cp -rf ../project/* .

$(BUILD_DIR)/pants/BUILD: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/pants $(BUILD_DIR)

## bazel

.PHONY: bazel
bazel: $(BUILD_DIR)/bazel/src $(BUILD_DIR)/bazel/BUILD
	$(info ******* bazel start)
	cd $(BUILD_DIR)/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests

$(BUILD_DIR)/bazel/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/bazel
	@cd $(BUILD_DIR)/bazel; cp -rf ../project/* .

$(BUILD_DIR)/bazel/BUILD: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/bazel $(BUILD_DIR)

## maven

.PHONY: maven
maven: $(BUILD_DIR)/maven/src $(BUILD_DIR)/maven/pom.xml
	$(info ******* maven start)
	cd $(BUILD_DIR)/maven; time mvn -q package -Dsurefire.printSummary=false

$(BUILD_DIR)/maven/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/maven
	@cd $(BUILD_DIR)/maven; cp -rf ../project/* .

$(BUILD_DIR)/maven/pom.xml: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/maven $(BUILD_DIR)

## gradle

.PHONY: gradle
gradle: $(BUILD_DIR)/gradle/src $(BUILD_DIR)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(BUILD_DIR)/gradle; time gradle -q test jar

$(BUILD_DIR)/gradle/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/gradle
	@cd $(BUILD_DIR)/gradle; cp -rf ../project/* .

$(BUILD_DIR)/gradle/build.gradle: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/gradle $(BUILD_DIR)

## sbt

.PHONY: sbt
sbt: $(BUILD_DIR)/sbt/src $(BUILD_DIR)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(BUILD_DIR)/sbt; time sbt -java-home $(JAVA_HOME) test package

$(BUILD_DIR)/sbt/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/sbt
	@cd $(BUILD_DIR)/sbt; cp -rf ../project/* .

$(BUILD_DIR)/sbt/build.sbt: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/sbt $(BUILD_DIR)

## buildr

.PHONY: buildr
buildr: $(BUILD_DIR)/buildr/src $(BUILD_DIR)/buildr/buildfile
	$(info ******* buildr start)
	cd $(BUILD_DIR)/buildr; time buildr -q package

$(BUILD_DIR)/buildr/src: $(BUILD_DIR)/project
	mkdir -p $(BUILD_DIR)/buildr
	@cd $(BUILD_DIR)/buildr; cp -rf ../project/* .

$(BUILD_DIR)/buildr/buildfile: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/buildr $(BUILD_DIR)

## Leiningen

.PHONY: leiningen
leiningen: $(BUILD_DIR)/leiningen/src $(BUILD_DIR)/leiningen/project.clj
	$(info ******* leiningen start)
# need hack to run both tests and jar? Using plugin to run junit tests
	cd $(BUILD_DIR)/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'

$(BUILD_DIR)/leiningen/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/leiningen
	@cd $(BUILD_DIR)/leiningen; cp -rf ../project/* .

$(BUILD_DIR)/leiningen/project.clj: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/leiningen $(BUILD_DIR)

## buck

.PHONY: buck
buck: $(BUILD_DIR)/buck/src $(BUILD_DIR)/buck/BUCK
	$(info ******* buck start)
	cd $(BUILD_DIR)/buck; time buck fetch //:junit
	cd $(BUILD_DIR)/buck; time buck fetch //:hamcrest-core
	cd $(BUILD_DIR)/buck; time buck test

$(BUILD_DIR)/buck/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/buck
	@cd $(BUILD_DIR)/buck; cp -rf ../project/* .

$(BUILD_DIR)/buck/BUCK: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/buck $(BUILD_DIR)

## ant_ivy

.PHONY: ant_ivy
ant_ivy: $(BUILD_DIR)/ivy/src $(BUILD_DIR)/ivy/build.xml
	$(info ******* ant-ivy start)
	cd $(BUILD_DIR)/ivy; time ant jar -q

$(BUILD_DIR)/ivy/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/ivy
	@cd $(BUILD_DIR)/ivy; cp -rf ../project/* .

$(BUILD_DIR)/ivy/build.xml: $(BUILD_DIR)/project
	@cp -rf templates/buildsystems/$(BUILD_DEFINITIONS)/ivy $(BUILD_DIR)



#
# Different sources to be used for benchmark
#

$(BUILD_DIR)/project: $(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)
	@mkdir -p $(BUILD_DIR)
# softlinking causes problems with some tools (pants)
	@cd $(BUILD_DIR); cp -rf ../$(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT) project

$(DOWNLOAD_SOURCES_DIR)/commons-math:
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



TEMPLATES_DIR=templates
FILE_NUM=2

$(DOWNLOAD_SOURCES_DIR)/simple: $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM)
	cp -r $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM) $(DOWNLOAD_SOURCES_DIR)/simple

$(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM):
	$(info Generating $(FILE_NUM) java source files)
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM)/src/main/java/com
	@for number in `seq 1 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/sources/simple/src/main --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM)/src/main/java/com/Simple$$number.java ; \
	done
	$(info Generating $(FILE_NUM) java test source files)
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM)/src/test/java/com
	@for number in `seq 1 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/sources/simple/src/test --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/simple-$(FILE_NUM)/src/test/java/com/Simple"$$number"Test.java ; \
	done


SUBPROJECT_NUM=3

$(DOWNLOAD_SOURCES_DIR)/multi: $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM)
	rm -rf $(DOWNLOAD_SOURCES_DIR)/multi
	cp -r $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM) $(DOWNLOAD_SOURCES_DIR)/multi

$(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM):
	$(info Generating $(SUBPROJECT_NUM) java projects)
	$(info Generating $(FILE_NUM) java source files in each subproject)

	@for pnumber in `seq 1 $(SUBPROJECT_NUM)` ; do \
		mkdir -p $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM)/subproject$$pnumber/src/main/java/com ; \
		mkdir -p $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM)/subproject$$pnumber/src/test/java/com ; \
	done

	@for pnumber in `seq 1 $(SUBPROJECT_NUM)` ; do \
		for number in `seq 1 $(FILE_NUM)` ; do \
	  	INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/sources/multi/src/main --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM)/subproject$$pnumber/src/main/java/com/Simple$$number.java ; \
		done ; \
	done

	$(info Generating $(FILE_NUM) java test source files in each subproject)
	@for pnumber in `seq 1 $(SUBPROJECT_NUM)` ; do \
		for number in `seq 1 $(FILE_NUM)` ; do \
	  	INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/sources/multi/src/test --env --nobackup -p >> $(DOWNLOAD_SOURCES_DIR)/multi-$(SUBPROJECT_NUM)-$(FILE_NUM)/subproject$$pnumber/src/test/java/com/Simple"$$number"Test.java ; \
		done ; \
	done
