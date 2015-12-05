.PHONY: default
default: leiningen

export LEININGEN_DIR=$(CACHE_DIR)/leiningen

.PHONY: leiningen
leiningen: leiningen$(LEININGEN_DEFAULT_VERSION)

.NOTPARALLEL: leiningen%
.PHONY: leiningen%
leiningen%: $(CONFIGURED_BUILD_ROOT)/leiningen/project.clj $(LEININGEN_DIR)/leiningen%/lein
	$(info ******* leiningen start)
## single project:
	@cd $(CONFIGURED_BUILD_ROOT)/leiningen	$(LEININGEN_DIR)/leiningen$*/lein --version
	cd $(CONFIGURED_BUILD_ROOT)/leiningen; time sh -c '$(LEININGEN_DIR)/leiningen$*/lein junit; $(LEININGEN_DIR)/leiningen$*/lein jar'


.PRECIOUS: $(LEININGEN_DIR)/leiningen-%-standalone.zip
$(LEININGEN_DIR)/leiningen-%-standalone.zip:
	@mkdir -p $(LEININGEN_DIR)
	@cd $(LEININGEN_DIR); wget https://github.com/technomancy/leiningen/releases/download/$*/leiningen-$*-standalone.zip

.PRECIOUS: $(LEININGEN_DIR)/leiningen%/lein
$(LEININGEN_DIR)/leiningen%/lein:
	@mkdir -p $(LEININGEN_DIR)/leiningen$*
	@cd $(LEININGEN_DIR)/leiningen$*; wget https://raw.githubusercontent.com/technomancy/leiningen/$*/bin/lein
	@chmod u+x $(LEININGEN_DIR)/leiningen$*/lein

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/leiningen/project.clj
$(CONFIGURED_BUILD_ROOT)/leiningen/project.clj: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/leiningen $(CONFIGURED_BUILD_ROOT)/leiningen --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
