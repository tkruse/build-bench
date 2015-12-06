# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

ifndef ROOT_DIR
export ROOT_DIR=$(shell readlink -m $(shell pwd)/../..)
endif

ifndef BUILD_DIR
include $(ROOT_DIR)/include/includes.mk
endif

include $(ROOT_DIR)/include/generators.mk

.PHONY: default
default: maven

include $(ROOT_DIR)/include/time.mk

export MAVEN_DIR=$(CACHE_DIR)/maven

.PHONY: maven
maven: maven$(MAVEN_DEFAULT_VERSION)

.PHONY: version
version: $(MAVEN_DIR)/maven$(MAVEN_DEFAULT_VERSION)/bin/mvn
	$(MAVEN_DIR)/maven$(MAVEN_DEFAULT_VERSION)/bin/mvn --version

.NOTPARALLEL: maven%
.PHONY: maven%
maven%: $(CONFIGURED_BUILD_ROOT)/maven%/pom.xml $(MAVEN_DIR)/maven%/bin/mvn $(TIME)
	$(info ******* maven start)
	cd $(CONFIGURED_BUILD_ROOT)/maven$*; $(TIME) $(MAVEN_DIR)/$@/bin/mvn -q -B -T 1C -gs $(BUILDSYSTEMS_DIR)/maven/settings.xml package -Dsurefire.printSummary=false


.PRECIOUS: $(MAVEN_DIR)/apache-maven-%-bin.tar.gz
$(MAVEN_DIR)/apache-maven-%-bin.tar.gz:
	@mkdir -p $(MAVEN_DIR)
	@cd $(MAVEN_DIR); wget http://mirror.serversupportforum.de/apache/maven/maven-3/$*/binaries/apache-maven-$*-bin.tar.gz

.PRECIOUS: $(MAVEN_DIR)/maven%/bin/mvn
$(MAVEN_DIR)/maven%/bin/mvn: $(MAVEN_DIR)/apache-maven-%-bin.tar.gz
	@mkdir -p $(MAVEN_DIR)/maven$*
	@cd $(MAVEN_DIR);tar -xzf apache-maven-$*-bin.tar.gz -C maven$* --strip-components 1

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/maven%/pom.xml
$(CONFIGURED_BUILD_ROOT)/maven%/pom.xml: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/maven $(CONFIGURED_BUILD_ROOT)/maven$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

