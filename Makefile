# only works when running make in root folder :-(
ROOT_DIR=$(shell pwd)
BUILD_DIR=build
RESULTS_DIR=$(BUILD_DIR)/results


TEMPLATES_DIR=templates

# templates/sources for buildsystems and project sources

# BUILD_DEFINITIONS=multiModule
# SOURCE_PROJECT=multi


BUILD_DEFINITIONS=singleModule
SOURCE_PROJECT=commons-math
# SOURCE_PROJECT=simple

# Configuration for template-based sources
FILE_NUM=2
SUBPROJECT_NUM=3

# folder containing source resources except for buildfiles
DOWNLOAD_SOURCES_DIR=buildsrc

JAVA_HOME=/usr/lib/jvm/java-8-oracle/

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

.PHONY: $(BUILD_DIR)/pants/src
$(BUILD_DIR)/pants/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/pants
# softlinking causes issues
	@cd $(BUILD_DIR)/pants; cp -rf ../project/* .

$(BUILD_DIR)/pants/BUILD: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/pants $(BUILD_DIR)/pants --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## bazel

.PHONY: bazel
bazel: $(BUILD_DIR)/bazel/src $(BUILD_DIR)/bazel/BUILD
	$(info ******* bazel start)
	cd $(BUILD_DIR)/bazel; bazel fetch -- :all
	cd $(BUILD_DIR)/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests

.PHONY: $(BUILD_DIR)/bazel/src
$(BUILD_DIR)/bazel/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/bazel
	@cd $(BUILD_DIR)/bazel; cp -rf ../project/* .

$(BUILD_DIR)/bazel/BUILD: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/bazel $(BUILD_DIR)/bazel --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## maven

.PHONY: maven
maven: $(BUILD_DIR)/maven/src $(BUILD_DIR)/maven/pom.xml
	$(info ******* maven start)
	cd $(BUILD_DIR)/maven; time mvn -q package -Dsurefire.printSummary=false

.PHONY: $(BUILD_DIR)/maven/src
$(BUILD_DIR)/maven/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/maven
	@cd $(BUILD_DIR)/maven; cp -rf ../project/* .

$(BUILD_DIR)/maven/pom.xml: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/maven $(BUILD_DIR)/maven --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## gradle

.PHONY: gradle
gradle: $(BUILD_DIR)/gradle/src $(BUILD_DIR)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(BUILD_DIR)/gradle; time gradle -q test jar

.PHONY: $(BUILD_DIR)/gradle/src
$(BUILD_DIR)/gradle/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/gradle
	@cd $(BUILD_DIR)/gradle; cp -rf ../project/* .

$(BUILD_DIR)/gradle/build.gradle: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/gradle $(BUILD_DIR)/gradle --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## sbt

.PHONY: sbt
sbt: $(BUILD_DIR)/sbt/src $(BUILD_DIR)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(BUILD_DIR)/sbt; time sbt -java-home $(JAVA_HOME) test package

.PHONY: $(BUILD_DIR)/sbt/src
$(BUILD_DIR)/sbt/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/sbt
	@cd $(BUILD_DIR)/sbt; cp -rf ../project/* .

$(BUILD_DIR)/sbt/build.sbt: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/sbt $(BUILD_DIR)/sbt --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)


## buildr

.PHONY: buildr
buildr: $(BUILD_DIR)/buildr/src $(BUILD_DIR)/buildr/buildfile
	$(info ******* buildr start)
	cd $(BUILD_DIR)/buildr; time buildr -q package

.PHONY: $(BUILD_DIR)/buildr/src
$(BUILD_DIR)/buildr/src: $(BUILD_DIR)/project
	mkdir -p $(BUILD_DIR)/buildr
	@cd $(BUILD_DIR)/buildr; cp -rf ../project/* .

$(BUILD_DIR)/buildr/buildfile: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/buildr $(BUILD_DIR)/buildr --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## Leiningen

.PHONY: leiningen
leiningen: $(BUILD_DIR)/leiningen/src $(BUILD_DIR)/leiningen/project.clj
	$(info ******* leiningen start)
# need hack to run both tests and jar? Using plugin to run junit tests
## single project:
#	cd $(BUILD_DIR)/leiningen; time sh -c 'lein junit; lein jar'
## multi project:
	cd $(BUILD_DIR)/leiningen; time sh -c 'lein sub junit; lein sub jar'

.PHONY: $(BUILD_DIR)/leiningen/src
$(BUILD_DIR)/leiningen/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/leiningen
	@cd $(BUILD_DIR)/leiningen; cp -rf ../project/* .

$(BUILD_DIR)/leiningen/project.clj: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/leiningen $(BUILD_DIR)/leiningen --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## buck

.PHONY: buck
buck: $(BUILD_DIR)/buck/src $(BUILD_DIR)/buck/BUCK
	$(info ******* buck start)
	cd $(BUILD_DIR)/buck; buck fetch //:junit
	cd $(BUILD_DIR)/buck; buck fetch //:hamcrest-core
	cd $(BUILD_DIR)/buck; time buck test --all

.PHONY: $(BUILD_DIR)/buck/src
$(BUILD_DIR)/buck/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/buck
	@cd $(BUILD_DIR)/buck; cp -rf ../project/* .

$(BUILD_DIR)/buck/BUCK: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/buck $(BUILD_DIR)/buck --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

## ant_ivy

.PHONY: ant_ivy
ant_ivy: $(BUILD_DIR)/ivy/src $(BUILD_DIR)/ivy/build.xml
	$(info ******* ant-ivy start)
	cd $(BUILD_DIR)/ivy; time ant jar -q

.PHONY: $(BUILD_DIR)/ivy/src
$(BUILD_DIR)/ivy/src: $(BUILD_DIR)/project
	@mkdir -p $(BUILD_DIR)/ivy
	@cd $(BUILD_DIR)/ivy; cp -rf ../project/* .

$(BUILD_DIR)/ivy/build.xml: $(BUILD_DIR)/project
	@python scripts/apply-templates.py templates/buildsystems/$(BUILD_DEFINITIONS)/ivy $(BUILD_DIR)/ivy --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)



#
# Different sources to be used for benchmark
#

$(BUILD_DIR)/project: $(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)
	@mkdir -p $(BUILD_DIR)
# softlinking causes problems with some tools (pants)
	@cd $(BUILD_DIR); cp -rf ../$(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT) project


$(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT): $(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT)-$(SUBPROJECT_NUM)-$(FILE_NUM)
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)
	cp -r $(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT)-$(SUBPROJECT_NUM)-$(FILE_NUM)/* $(DOWNLOAD_SOURCES_DIR)/$(SOURCE_PROJECT)

$(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT)-$(SUBPROJECT_NUM)-$(FILE_NUM):
	$(info Generating $(FILE_NUM) java source files)
	@python scripts/apply-templates.py $(TEMPLATES_DIR)/sources/$(SOURCE_PROJECT) $(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT)-$(SUBPROJECT_NUM)-$(FILE_NUM) --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

$(DOWNLOAD_SOURCES_DIR)/simple: $(DOWNLOAD_SOURCES_DIR)/generated/simple

$(DOWNLOAD_SOURCES_DIR)/multi: $(DOWNLOAD_SOURCES_DIR)/generated/multi

# intentionally overriding generic rules above
$(DOWNLOAD_SOURCES_DIR)/commons-math:
	@mkdir -p $(DOWNLOAD_SOURCES_DIR)
	cd $(DOWNLOAD_SOURCES_DIR); git clone https://git-wip-us.apache.org/repos/asf/commons-math.git; cd commons-math; git checkout MATH_3_4
# Sadly this test fails with buck because java.io.File cannot handle uris inside jars.
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/random/EmpiricalDistributionTest.java
# This test fails with with buck for unknown reasons of comparing floating points to zero.
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/ml/neuralnet/sofm/KohonenUpdateActionTest.java
# Some actual Tests sadly do not end with Test.java, so for fairness sake they cannot be used
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/fitting/leastsquares/EvaluationTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestBinary.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestPermutations.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/optim/nonlinear/vector/jacobian/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/optimization/general/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(DOWNLOAD_SOURCES_DIR)/commons-math/src/test/java/org/apache/commons/math3/util/FastMathTestPerformance.java
	mv $(DOWNLOAD_SOURCES_DIR)/commons-math/pom.xml $(DOWNLOAD_SOURCES_DIR)/commons-math/pom.xml.bak
	mv $(DOWNLOAD_SOURCES_DIR)/commons-math/build.xml $(DOWNLOAD_SOURCES_DIR)/commons-math/build.xml.bak
