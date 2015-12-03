.PHONY: default
default: pants


## pants
# Assuming pants is globally installed, even though
# typically pants may be a local executable

.PHONY: pants
pants: $(CONFIGURED_BUILD_ROOT)/pants/BUILD
	$(info ******* pants start)
	cd $(CONFIGURED_BUILD_ROOT)/pants; time pants test :test -q


$(CONFIGURED_BUILD_ROOT)/pants/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/pants $(CONFIGURED_BUILD_ROOT)/pants --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
