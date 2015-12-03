.PHONY: default
default: buck


.PHONY: buck
buck: $(CONFIGURED_BUILD_ROOT)/buck/BUCK
	$(info ******* buck start)
	cd $(CONFIGURED_BUILD_ROOT)/buck; buck fetch //:junit
	cd $(CONFIGURED_BUILD_ROOT)/buck; buck fetch //:hamcrest-core
	cd $(CONFIGURED_BUILD_ROOT)/buck; time buck test --all


$(CONFIGURED_BUILD_ROOT)/buck/BUCK: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/buck $(CONFIGURED_BUILD_ROOT)/buck --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

