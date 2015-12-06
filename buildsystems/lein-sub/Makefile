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
default: lein-sub

include $(ROOT_DIR)/include/time.mk
include $(ROOT_DIR)/include/leiningen.mk


# special leiningen build for multi-module projects with lein-sub (lein invocation is different)

.PHONY: default
default: lein-sub

.PHONY: version
version: $(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein
	$(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein --version

.PHONY: lein-sub
lein-sub: lein-sub$(LEININGEN_DEFAULT_VERSION)

.NOTPARALLEL: lein-sub%
.PHONY: lein-sub%
lein-sub%: $(CONFIGURED_BUILD_ROOT)/lein-sub%/project.clj $(LEININGEN_DIR)/leiningen%/lein $(TIME)
	$(info ******* leiningen start)
## multi project:
	@cd $(CONFIGURED_BUILD_ROOT)/lein-sub$*; $(LEININGEN_DIR)/leiningen$*/lein --version
	cd $(CONFIGURED_BUILD_ROOT)/lein-sub$*; $(TIME) sh -c '$(LEININGEN_DIR)/leiningen$*/lein sub junit; $(LEININGEN_DIR)/leiningen$*/lein sub jar'

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/lein-sub%/project.clj
$(CONFIGURED_BUILD_ROOT)/lein-sub%/project.clj: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/lein-sub $(CONFIGURED_BUILD_ROOT)/lein-sub$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
