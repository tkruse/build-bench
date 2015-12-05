# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: default
default: leiningen

include ../../include/time.mk
include ../../include/leiningen.mk

.PHONY: leiningen
leiningen: leiningen$(LEININGEN_DEFAULT_VERSION)

.PHONY: version
version: $(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein
	$(LEININGEN_DIR)/leiningen$(LEININGEN_DEFAULT_VERSION)/lein --version

.NOTPARALLEL: leiningen%
.PHONY: leiningen%
leiningen%: $(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj $(LEININGEN_DIR)/leiningen%/lein $(TIME)
	$(info ******* leiningen start)
## single project:
	@cd $(CONFIGURED_BUILD_ROOT)/leiningen$*; $(LEININGEN_DIR)/leiningen$*/lein --version
	cd $(CONFIGURED_BUILD_ROOT)/leiningen$*; $(TIME) sh -c '$(LEININGEN_DIR)/leiningen$*/lein junit; $(LEININGEN_DIR)/leiningen$*/lein jar'

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj
$(CONFIGURED_BUILD_ROOT)/leiningen%/project.clj: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/leiningen $(CONFIGURED_BUILD_ROOT)/leiningen$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
