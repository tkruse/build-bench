.PHONY: default
default: buck

include ../../include/ant.mk

export BUCK_DIR=$(CACHE_DIR)/buck
# ant version could be independent for buck
export ANT_IVY_PATH=$(ANT_IVY_DIR)/ant_ivy$(ANT_DEFAULT_VERSION)/bin

.PHONY: buck
buck: buck$(BUCK_DEFAULT_VERSION)

.PHONY: version
version: $(BUCK_DIR)/buck$(BUCK_DEFAULT_VERSION)/bin/buck
	@cd $(BUCK_DIR); $(BUCK_DIR)/buck$(BUCK_DEFAULT_VERSION)/bin/buck --version

.NOTPARALLEL: buck%
.PHONY: buck%
buck%: $(CONFIGURED_BUILD_ROOT)/buck/BUCK $(BUCK_DIR)/buck%/bin/buck $(ANT)
	$(info ******* buck start)
	cd $(CONFIGURED_BUILD_ROOT)/buck; ANT_HOME=$(ANT_HOME) PATH=$(ANT_IVY_PATH):$(PATH) $(BUCK_DIR)/buck$*/bin/buck fetch //:junit
	@cd $(CONFIGURED_BUILD_ROOT)/buck; ANT_HOME=$(ANT_HOME) PATH=$(ANT_IVY_PATH):$(PATH) $(BUCK_DIR)/buck$*/bin/buck fetch //:hamcrest-core
	cd $(CONFIGURED_BUILD_ROOT)/buck; ANT_HOME=$(ANT_HOME) PATH=$(ANT_IVY_PATH):$(PATH) $(BUCK_DIR)/buck$*/bin/buck test -v 0 --all

.PRECIOUS: $(BUCK_DIR)/%.zip
$(BUCK_DIR)/%.zip:
	@mkdir -p $(BUCK_DIR)
	@cd $(BUCK_DIR); wget https://github.com/facebook/buck/archive/$*.zip

.PRECIOUS: $(BUCK_DIR)/buck%/bin/buck
$(BUCK_DIR)/buck%/bin/buck: $(BUCK_DIR)/%.zip $(ANT_IVY_PATH)/ant
	@mkdir -p $(BUCK_DIR)
	@cd $(BUCK_DIR); unzip -u -q $*.zip; mv buck-$(subst v,,$*) buck$*
	@cd $(BUCK_DIR);touch buck$*/bin/buck

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/buck/build.buck
$(CONFIGURED_BUILD_ROOT)/buck/BUCK: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/buck $(CONFIGURED_BUILD_ROOT)/buck --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
