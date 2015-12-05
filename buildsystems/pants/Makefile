.PHONY: default
default: pants

export PANTS_DIR=$(CACHE_DIR)/pants
# ant version could be independent for pants
export ANT_IVY_PATH=$(CACHE_DIR)/ant_ivy/ant_ivy$(ANT_VERSION)/bin

.PHONY: pants
pants: pants$(PANTS_DEFAULT_VERSION)

.NOTPARALLEL: pants%
.PHONY: pants%
pants%: $(CONFIGURED_BUILD_ROOT)/pants/BUILD $(PANTS_DIR)/pants $(CONFIGURED_BUILD_ROOT)/pants/pants.ini%
	$(info ******* pants start)
	@cd $(CONFIGURED_BUILD_ROOT)/pants; time $(PANTS_DIR)/pants --version
	cd $(CONFIGURED_BUILD_ROOT)/pants; time $(PANTS_DIR)/pants test :test


# pants insists on being installed via virtualenv, version configured in project
.PRECIOUS: $(PANTS_DIR)/pants
$(PANTS_DIR)/pants:
	@mkdir -p $(PANTS_DIR)
	@cd $(PANTS_DIR); curl -O https://pantsbuild.github.io/setup/pants
	@chmod u+x $(PANTS_DIR)/pants

# make sure correct pants_version configured in project workspace
.PHONY: $(CONFIGURED_BUILD_ROOT)/pants/pants.ini%
$(CONFIGURED_BUILD_ROOT)/pants/pants.ini%: $(CONFIGURED_BUILD_ROOT)/pants/BUILD
# intentionally avoiding sed -i because it is not cross compatible
	@sed 's/pants_version.*$$/pants_version: $*/g'  $(CONFIGURED_BUILD_ROOT)/pants/pants.ini >  $(CONFIGURED_BUILD_ROOT)/pants/pants.ini.tmp && mv  $(CONFIGURED_BUILD_ROOT)/pants/pants.ini.tmp  $(CONFIGURED_BUILD_ROOT)/pants/pants.ini


.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/pants/BUILD
$(CONFIGURED_BUILD_ROOT)/pants/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/pants $(CONFIGURED_BUILD_ROOT)/pants --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
