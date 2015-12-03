.PHONY: default
default: leiningen

# special leiningen build for multi-module projects with lein-sub

.PHONY: leiningen
leiningen: $(CONFIGURED_BUILD_ROOT)/leiningen/src $(CONFIGURED_BUILD_ROOT)/leiningen/project.clj
	$(info ******* leiningen start)
## multi project:
	cd $(CONFIGURED_BUILD_ROOT)/leiningen; time sh -c 'lein sub junit; lein sub jar'



$(CONFIGURED_BUILD_ROOT)/leiningen/project.clj: $(CONFIGURED_BUILD_ROOT)/$(SOURCE_PROJECT)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/leiningen $(CONFIGURED_BUILD_ROOT)/leiningen --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
