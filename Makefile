
BUILD_DIR=build
RESULTS_DIR=$(BUILD_DIR)/results
TEMPLATES_DIR=templates
FILE_NUM=500
JAVA_HOME=/usr/lib/jvm/java-7-oracle/

.PHONY: default
default: all

.PHONY: clean
clean:
	rm -rf build

.PHONY: all
all: versions\
$(RESULTS_DIR)/buildr/output.txt \
$(RESULTS_DIR)/maven/output.txt \
$(RESULTS_DIR)/sbt/output.txt \
$(RESULTS_DIR)/gradle/output.txt \

.PHONY: versions
versions:
	java -version
	mvn --version
	gradle --version
	sbt --version
	buildr --version


## maven

$(RESULTS_DIR)/maven/output.txt: $(BUILD_DIR)/maven/src $(BUILD_DIR)/maven/pom.xml
	$(info ******* maven start)
	cd $(BUILD_DIR)/maven; time mvn -q package -Dsurefire.printSummary=false

$(BUILD_DIR)/maven/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/maven
	cd $(BUILD_DIR)/maven; ln -s ../src

$(BUILD_DIR)/maven/pom.xml: $(BUILD_DIR)/src
	cheetah fill --quiet -R --idir $(TEMPLATES_DIR)/maven --odir $(BUILD_DIR)/maven --nobackup --oext xml

## gradle

$(RESULTS_DIR)/gradle/output.txt: $(BUILD_DIR)/gradle/src $(BUILD_DIR)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(BUILD_DIR)/gradle; time gradle -q jar

$(BUILD_DIR)/gradle/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/gradle
	cd $(BUILD_DIR)/gradle; ln -s ../src

$(BUILD_DIR)/gradle/build.gradle: $(BUILD_DIR)/src
	echo "rootProject.name = 'project1'" > $(BUILD_DIR)/gradle/settings.gradle
	cheetah fill --quiet  -R --idir $(TEMPLATES_DIR)/gradle --odir $(BUILD_DIR)/gradle --nobackup --oext gradle

## sbt

$(RESULTS_DIR)/sbt/output.txt: $(BUILD_DIR)/sbt/src $(BUILD_DIR)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(BUILD_DIR)/sbt; time sbt -java-home $(JAVA_HOME) -q test package

$(BUILD_DIR)/sbt/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/sbt
	cd $(BUILD_DIR)/sbt; ln -s ../src

$(BUILD_DIR)/sbt/build.sbt: $(BUILD_DIR)/src
	cheetah fill --quiet  -R --idir $(TEMPLATES_DIR)/sbt --odir $(BUILD_DIR)/sbt --nobackup --oext sbt

## buildr

$(RESULTS_DIR)/buildr/output.txt: $(BUILD_DIR)/buildr/src $(BUILD_DIR)/buildr/buildfile
	$(info ******* buildr start)
	cd $(BUILD_DIR)/buildr; time buildr -q package

$(BUILD_DIR)/buildr/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/buildr
	cd $(BUILD_DIR)/buildr; ln -s ../src

$(BUILD_DIR)/buildr/buildfile: $(BUILD_DIR)/src
	CLASSPATH=;cheetah fill --quiet  -R --idir $(TEMPLATES_DIR)/buildr --odir $(BUILD_DIR)/buildr
	mv $(BUILD_DIR)/buildr/buildfile.html $(BUILD_DIR)/buildr/buildfile

## Leiningen

$(RESULTS_DIR)/leiningen/output.txt: $(BUILD_DIR)/leiningen/src $(BUILD_DIR)/leiningen/project.clj
	$(info ******* leiningen start)
	cd $(BUILD_DIR)/leiningen; time lein jar

$(BUILD_DIR)/leiningen/src: $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/leiningen
	cd $(BUILD_DIR)/leiningen; ln -s ../src

$(BUILD_DIR)/leiningen/project.clj: $(BUILD_DIR)/src
	cheetah fill --quiet  -R --idir $(TEMPLATES_DIR)/leiningen --odir $(BUILD_DIR)/leiningen --nobackup --oext clj


## regen sources
$(BUILD_DIR)/src:
	mkdir $(BUILD_DIR)
	cd $(BUILD_DIR); ln -s ../3rdparty/src

$(BUILD_DIR)/src2:
	$(info Generating $(FILE_NUM) java source files)
	mkdir -p $(BUILD_DIR)/src/main/java/com
	for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/src/main --env --nobackup -p >> $(BUILD_DIR)/src/main/java/com/Simple$$number.java ; \
	done
	$(info Generating $(FILE_NUM) java test source files)
	mkdir -p $(BUILD_DIR)/src/test/java/com
	for number in `seq 0 $(FILE_NUM)` ; do \
	  INDEX=$$number cheetah fill -R --idir $(TEMPLATES_DIR)/src/test --env --nobackup -p >> $(BUILD_DIR)/src/test/java/com/Simple"$$number"Test.java ; \
	done