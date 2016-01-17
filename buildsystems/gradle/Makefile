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
default: gradle

include $(ROOT_DIR)/include/time.mk

export GRADLE_DIR=$(CACHE_DIR)/gradle

.PHONY: gradle
gradle: gradle$(GRADLE_DEFAULT_VERSION)

.PHONY: version
version: $(GRADLE_DIR)/gradle$(GRADLE_DEFAULT_VERSION)/bin/gradle
	$(GRADLE_DIR)/gradle$(GRADLE_DEFAULT_VERSION)/bin/gradle --version

.NOTPARALLEL: gradle%
.PHONY: gradle%
gradle%: $(CONFIGURED_BUILD_ROOT)/gradle%/build.gradle $(GRADLE_DIR)/gradle%/bin/gradle $(REPORTS_DIR)/$(TARGET_NAME).csv
	$(info ******* gradle start)
	@cd $(CONFIGURED_BUILD_ROOT)/gradle$*; $(GRADLE_DIR)/$@/bin/gradle --stop
	@cd $(CONFIGURED_BUILD_ROOT)/gradle$*; $(GRADLE_DIR)/$@/bin/gradle -v
	cd $(CONFIGURED_BUILD_ROOT)/gradle$*; $(call TIME_CMD,$@) $(GRADLE_DIR)/$@/bin/gradle -q --info --stacktrace test jar

.PRECIOUS: $(GRADLE_DIR)/gradle-%-bin.zip
$(GRADLE_DIR)/gradle-%-bin.zip:
	@mkdir -p $(GRADLE_DIR)
	@cd $(GRADLE_DIR); wget --quiet https://services.gradle.org/distributions/gradle-$*-bin.zip

.PRECIOUS: $(GRADLE_DIR)/gradle%/bin/gradle
$(GRADLE_DIR)/gradle%/bin/gradle: $(GRADLE_DIR)/gradle-%-bin.zip
	@mkdir -p $(GRADLE_DIR)
	@cd $(GRADLE_DIR); unzip -u -q gradle-$*-bin.zip; mv gradle-$* gradle$*
	@touch $(GRADLE_DIR)/gradle$*/bin/gradle

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/gradle%/build.gradle
$(CONFIGURED_BUILD_ROOT)/gradle%/build.gradle: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/gradle $(CONFIGURED_BUILD_ROOT)/gradle$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
