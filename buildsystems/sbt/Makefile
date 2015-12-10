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
default: sbt

include $(ROOT_DIR)/include/time.mk

export SBT_DIR=$(CACHE_DIR)/sbt

.PHONY: sbt
sbt: sbt$(SBT_DEFAULT_VERSION)


.PHONY: version
version: $(SBT_DIR)/sbt$(SBT_DEFAULT_VERSION)/bin/sbt
	$(SBT_DIR)/sbt$(SBT_DEFAULT_VERSION)/bin/sbt about


.NOTPARALLEL: sbt%
.PHONY: sbt%
sbt%: $(CONFIGURED_BUILD_ROOT)/sbt%/build.sbt $(SBT_DIR)/sbt%/bin/sbt $(TIME) $(REPORTS_DIR)
	cd $(CONFIGURED_BUILD_ROOT)/sbt$*; $(SBT_DIR)/$@/bin/sbt -java-home $(JAVA_HOME) about
	$(info ******* sbt start)
	cd $(CONFIGURED_BUILD_ROOT)/sbt$*; $(call TIME_CMD,$@) $(SBT_DIR)/$@/bin/sbt -java-home $(JAVA_HOME) test package


.PRECIOUS: $(SBT_DIR)/sbt-%.tgz
$(SBT_DIR)/sbt-%.tgz:
	@mkdir -p $(SBT_DIR)
	@cd $(SBT_DIR); wget --quiet https://dl.bintray.com/sbt/native-packages/sbt/$*/sbt-$*.tgz

.PRECIOUS: $(SBT_DIR)/sbt%/bin/sbt
$(SBT_DIR)/sbt%/bin/sbt: $(SBT_DIR)/sbt-%.tgz
	@mkdir -p $(SBT_DIR)/sbt$*
	@cd $(SBT_DIR);tar -xzf sbt-$*.tgz -C sbt$* --strip-components 1

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/sbt%/build.sbt
$(CONFIGURED_BUILD_ROOT)/sbt%/build.sbt: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/sbt $(CONFIGURED_BUILD_ROOT)/sbt$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

