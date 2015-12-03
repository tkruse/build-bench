.PHONY: default
default: gradle

.PHONY: gradle
gradle: $(CONFIGURED_BUILD_ROOT)/gradle/build.gradle
	$(info ******* gradle start)
	cd $(CONFIGURED_BUILD_ROOT)/gradle; time gradle -q test jar


$(CONFIGURED_BUILD_ROOT)/gradle/build.gradle: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/gradle $(CONFIGURED_BUILD_ROOT)/gradle --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
