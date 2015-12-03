.PHONY: default
default: sbt


.PHONY: sbt
sbt: $(CONFIGURED_BUILD_ROOT)/sbt/build.sbt
	$(info ******* sbt start)
	cd $(CONFIGURED_BUILD_ROOT)/sbt; time sbt -java-home $(JAVA_HOME) test package


$(CONFIGURED_BUILD_ROOT)/sbt/build.sbt: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/sbt $(CONFIGURED_BUILD_ROOT)/sbt --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

