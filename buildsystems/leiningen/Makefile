.PHONY: default
default: leiningen



.PHONY: leiningen
leiningen: $(CONFIGURED_BUILD_ROOT)/leiningen/src $(CONFIGURED_BUILD_ROOT)/leiningen/project.clj
	$(info ******* leiningen start)
## single project:
	cd $(CONFIGURED_BUILD_ROOT)/leiningen; time sh -c 'lein junit; lein jar'



$(CONFIGURED_BUILD_ROOT)/leiningen/project.clj: $(CONFIGURED_BUILD_ROOT)/$(SOURCE_PROJECT)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/leiningen $(CONFIGURED_BUILD_ROOT)/leiningen --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
