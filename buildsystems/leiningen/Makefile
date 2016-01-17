# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

ifndef ROOT_DIR
export ROOT_DIR=$(shell readlink -m $(shell pwd)/../..)
endif

ifndef BUILD_DIR
include $(ROOT_DIR)/include/includes.mk
endif

.PHONY: default
default: leiningen

include $(ROOT_DIR)/include/generators.mk
include $(ROOT_DIR)/include/time.mk
include $(ROOT_DIR)/include/leiningen.mk

.PHONY: leiningen
leiningen: leiningen$(LEININGEN_DEFAULT_VERSION)

.PHONY: version
version: $(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein
	$(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein --version

.NOTPARALLEL: leiningen%
.PHONY: leiningen%
leiningen%: $(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj $(LEININGEN_DIR)/leiningen%/lein $(REPORTS_DIR)/$(TARGET_NAME).csv
	$(info ******* leiningen start)
## single project:
	@cd $(CONFIGURED_BUILD_ROOT)/leiningen$*; $(LEININGEN_DIR)/leiningen$*/lein --version
	cd $(CONFIGURED_BUILD_ROOT)/leiningen$*; $(call TIME_CMD,$@) sh -c '$(LEININGEN_DIR)/leiningen$*/lein junit && $(LEININGEN_DIR)/leiningen$*/lein jar'

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj
$(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/leiningen $(CONFIGURED_BUILD_ROOT)/leiningen$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
