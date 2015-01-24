# only works when running make in root folder :-(
ROOT_DIR = $(shell pwd)
BUILD_DIR=build
RESULTS_DIR=$(BUILD_DIR)/results

# Folder with structures for running buildsystems
BUILD_DEFINITIONS=singleModule
# folder containing source resources except for buildfiles
SOURCES_DIR=$(BUILD_DEFINITIONS)/apacheCommons

TEMPLATES_DIR=templates
FILE_NUM=5
JAVA_HOME=/usr/lib/jvm/java-7-oracle/

.PHONY: default
default: all

.PHONY: clean
clean:
	rm -rf build

.PHONY: all
all: \
leiningen \
ivy \
gradle \
buck \
maven \
buildr \
sbt \



.PHONY: versions
versions:
	java -version
	mvn --version
	gradle --version
	sbt --version
	buildr --version
	buck --version
	ant -version


## maven

.PHONY: maven
maven: $(BUILD_DIR)/maven/src $(BUILD_DIR)/maven/pom.xml
	$(info ******* maven start)
	cd $(BUILD_DIR)/maven; time mvn -q package -Dsurefire.printSummary=false

$(BUILD_DIR)/maven/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/maven
	cd $(BUILD_DIR)/maven; ln -s ../src

$(BUILD_DIR)/maven/pom.xml: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/maven $(BUILD_DIR)

## gradle

.PHONY: gradle
gradle: $(BUILD_DIR)/gradle/src $(BUILD_DIR)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(BUILD_DIR)/gradle; time gradle -q test jar

$(BUILD_DIR)/gradle/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/gradle
	cd $(BUILD_DIR)/gradle; ln -s ../src

$(BUILD_DIR)/gradle/build.gradle: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/gradle $(BUILD_DIR)

## sbt

.PHONY: sbt
sbt: $(BUILD_DIR)/sbt/src $(BUILD_DIR)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(BUILD_DIR)/sbt; time sbt -java-home $(JAVA_HOME) -q test package

$(BUILD_DIR)/sbt/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/sbt
	cd $(BUILD_DIR)/sbt; ln -s ../src

$(BUILD_DIR)/sbt/build.sbt: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/sbt $(BUILD_DIR)

## buildr

.PHONY: buildr
buildr: $(BUILD_DIR)/buildr/src $(BUILD_DIR)/buildr/buildfile
	$(info ******* buildr start)
	cd $(BUILD_DIR)/buildr; time buildr -q package

$(BUILD_DIR)/buildr/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/buildr
	cd $(BUILD_DIR)/buildr; ln -s ../src

$(BUILD_DIR)/buildr/buildfile: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/buildr $(BUILD_DIR)

## Leiningen

.PHONY: leiningen
leiningen: $(BUILD_DIR)/leiningen/src $(BUILD_DIR)/leiningen/project.clj
	$(info ******* leiningen start)
# need hack to run both tests and jar? Using plugin to run junit tests
	cd $(BUILD_DIR)/leiningen; LEIN_SILENT=true time sh -c 'lein junit; lein jar'

$(BUILD_DIR)/leiningen/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/leiningen
	cd $(BUILD_DIR)/leiningen; ln -s ../src

$(BUILD_DIR)/leiningen/project.clj: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/leiningen $(BUILD_DIR)

## buck

.PHONY: buck
buck: $(BUILD_DIR)/buck/src $(BUILD_DIR)/buck/BUCK
	$(info ******* buck start)
	cd $(BUILD_DIR)/buck; time buck test

$(BUILD_DIR)/buck/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/buck
	cd $(BUILD_DIR)/buck; ln -s ../src

$(BUILD_DIR)/buck/BUCK: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/buck $(BUILD_DIR)

## ivy

.PHONY: ivy
ivy: $(BUILD_DIR)/ivy/src $(BUILD_DIR)/ivy/build.xml
	$(info ******* ant-ivy start)
	cd $(BUILD_DIR)/ivy; time ant jar -q

$(BUILD_DIR)/ivy/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/ivy
	cd $(BUILD_DIR)/ivy; ln -s ../src

$(BUILD_DIR)/ivy/build.xml: $(BUILD_DIR)/src
	cp -r $(BUILD_DEFINITIONS)/ivy $(BUILD_DIR)



#
# Different sources to be used for benchmark
#


$(BUILD_DIR)/src2:
	mkdir $(BUILD_DIR)
# 	cd $(SOURCES_DIR); git clone https://git-wip-us.apache.org/repos/asf/commons-math.git
# 	cd $(SOURCES_DIR); git clone https://git-wip-us.apache.org/repos/asf/commons-text.git
# 	cd $(SOURCES_DIR); svn checkout https://svn.apache.org/repos/asf/commons/proper/net/trunk commons-net
	cd $(BUILD_DIR); ln -s ../$(SOURCES_DIR)/src

$(BUILD_DIR)/src:
	$(info Generating $(FILE_NUM) java source files)
	mkdir -p $(BUILD_DIR)/src/main/java/com
	for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/simple/src/main --env --nobackup -p >> $(BUILD_DIR)/src/main/java/com/Simple$$number.java ; \
	done
	$(info Generating $(FILE_NUM) java test source files)
	mkdir -p $(BUILD_DIR)/src/test/java/com
	for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/simple/src/test --env --nobackup -p >> $(BUILD_DIR)/src/test/java/com/Simple"$$number"Test.java ; \
	done