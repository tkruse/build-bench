.PHONY: default
default: ant_ivy


.PHONY: ant_ivy
ant_ivy: $(CONFIGURED_BUILD_ROOT)/ant_ivy/build.xml
	$(info ******* ant-ivy start)
	cd $(CONFIGURED_BUILD_ROOT)/ant_ivy; time ant jar -q


$(CONFIGURED_BUILD_ROOT)/ant_ivy/build.xml: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/ant_ivy $(CONFIGURED_BUILD_ROOT)/ant_ivy --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

