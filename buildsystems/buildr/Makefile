.PHONY: default
default: buildr

.PHONY: buildr
buildr: $(CONFIGURED_BUILD_ROOT)/buildr/buildfile
	$(info ******* buildr start)
	cd $(CONFIGURED_BUILD_ROOT)/buildr; time buildr -q package


$(CONFIGURED_BUILD_ROOT)/buildr/buildfile: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/buildr $(CONFIGURED_BUILD_ROOT)/buildr --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

