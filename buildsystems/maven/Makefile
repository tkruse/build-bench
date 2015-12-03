.PHONY: default
default: maven

.PHONY: maven
maven: $(CONFIGURED_BUILD_ROOT)/maven/pom.xml
	$(info ******* maven start)
	cd $(CONFIGURED_BUILD_ROOT)/maven; time mvn -q package -Dsurefire.printSummary=false


$(CONFIGURED_BUILD_ROOT)/maven/pom.xml: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/maven $(CONFIGURED_BUILD_ROOT)/maven --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

