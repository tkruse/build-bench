.PHONY: default
default: gradle

export GRADLE_DIR=$(CACHE_DIR)/gradle

.PHONY: gradle
gradle: gradle$(GRADLE_VERSION)

.NOTPARALLEL: gradle%
.PHONY: gradle%
gradle%: $(CONFIGURED_BUILD_ROOT)/gradle/build.gradle $(GRADLE_DIR)/gradle%/bin/gradle
	$(info ******* gradle start)
	@cd $(CONFIGURED_BUILD_ROOT)/gradle; $(GRADLE_DIR)/$@/bin/gradle --stop
	@cd $(CONFIGURED_BUILD_ROOT)/gradle; $(GRADLE_DIR)/$@/bin/gradle -v
	cd $(CONFIGURED_BUILD_ROOT)/gradle; time $(GRADLE_DIR)/$@/bin/gradle -q test jar

.PRECIOUS: $(GRADLE_DIR)/gradle-%-bin.zip
$(GRADLE_DIR)/gradle-%-bin.zip:
	@mkdir -p $(GRADLE_DIR)
	@cd $(GRADLE_DIR); wget https://services.gradle.org/distributions/gradle-$*-bin.zip

.PRECIOUS: $(GRADLE_DIR)/gradle%/bin/gradle
$(GRADLE_DIR)/gradle%/bin/gradle: $(GRADLE_DIR)/gradle-%-bin.zip
	@mkdir -p $(GRADLE_DIR)
	@cd $(GRADLE_DIR); unzip gradle-$*-bin.zip; mv gradle-$* gradle$*

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/gradle/build.gradle
$(CONFIGURED_BUILD_ROOT)/gradle/build.gradle: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/gradle $(CONFIGURED_BUILD_ROOT)/gradle --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
