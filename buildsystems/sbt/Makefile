.PHONY: default
default: sbt


export SBT_DIR=$(CACHE_DIR)/sbt

.PHONY: sbt
sbt: sbt$(SBT_VERSION)



.NOTPARALLEL: sbt%
sbt%: $(CONFIGURED_BUILD_ROOT)/sbt/build.sbt $(SBT_DIR)/sbt%/bin/sbt
	$(info ******* sbt start)
	cd $(CONFIGURED_BUILD_ROOT)/sbt; time $(SBT_DIR)/$@/bin/sbt -java-home $(JAVA_HOME) test package


.PRECIOUS: $(SBT_DIR)/sbt-%.tgz
$(SBT_DIR)/sbt-%.tgz:
	@mkdir -p $(SBT_DIR)
	@cd $(SBT_DIR); wget https://dl.bintray.com/sbt/native-packages/sbt/$*/sbt-$*.tgz

.PRECIOUS: $(SBT_DIR)/sbt%/bin/sbt
$(SBT_DIR)/sbt%/bin/sbt: $(SBT_DIR)/sbt-%.tgz
	@mkdir -p $(SBT_DIR)/sbt$*
	@cd $(SBT_DIR);tar -xzf sbt-$*.tgz -C sbt$* --strip-components 1


$(CONFIGURED_BUILD_ROOT)/sbt/build.sbt: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/sbt $(CONFIGURED_BUILD_ROOT)/sbt --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

