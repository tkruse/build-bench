# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

ifndef ROOT_DIR
export ROOT_DIR=$(shell readlink -m $(shell pwd)/../..)
endif

ifndef BUILD_DIR
include $(ROOT_DIR)/include/includes.mk
endif

include $(ROOT_DIR)/include/generators.mk

.PHONY: default
default: pants

include $(ROOT_DIR)/include/time.mk

export PANTS_DIR=$(CACHE_DIR)/pants
# ant version could be independent for pants
export ANT_IVY_PATH=$(CACHE_DIR)/ant_ivy/ant_ivy$(ANT_VERSION)/bin

.PHONY: pants
pants: pants$(PANTS_DEFAULT_VERSION)

.PHONY: version
version: $(PANTS_DIR)/pants
	@cd $(PANTS_DIR); touch pants.ini
	@cd $(PANTS_DIR); $(PANTS_DIR)/pants --version

.NOTPARALLEL: pants%
.PHONY: pants%
pants%: $(CONFIGURED_BUILD_ROOT)/pants%/BUILD $(PANTS_DIR)/pants $(CONFIGURED_BUILD_ROOT)/pants%/pants.ini% $(TIME) $(REPORTS_DIR)
	$(info ******* pants start)
	# Do one throw-away run to ensure all tools are shaded.
	@cd $(CONFIGURED_BUILD_ROOT)/pants$*; $(PANTS_DIR)/pants test :test
	@cd $(CONFIGURED_BUILD_ROOT)/pants$*; $(PANTS_DIR)/pants clean-all
	cd $(CONFIGURED_BUILD_ROOT)/pants$*; $(call TIME_CMD,$@) $(PANTS_DIR)/pants test :test


# pants insists on being installed via virtualenv, version configured in project
.PRECIOUS: $(PANTS_DIR)/pants
$(PANTS_DIR)/pants:
	@mkdir -p $(PANTS_DIR)
	@cd $(PANTS_DIR); curl -s -O https://pantsbuild.github.io/setup/pants
	@chmod u+x $(PANTS_DIR)/pants

# make sure correct pants_version configured in project workspace
.PHONY: $(CONFIGURED_BUILD_ROOT)/pants%/pants.ini%
$(CONFIGURED_BUILD_ROOT)/pants%/pants.ini%: $(CONFIGURED_BUILD_ROOT)/pants%/BUILD
# intentionally avoiding sed -i because it is not cross compatible
	@sed 's/pants_version.*$$/pants_version: $*/g'  $(CONFIGURED_BUILD_ROOT)/pants$*/pants.ini >  $(CONFIGURED_BUILD_ROOT)/pants$*/pants.ini.tmp && mv  $(CONFIGURED_BUILD_ROOT)/pants$*/pants.ini.tmp  $(CONFIGURED_BUILD_ROOT)/pants$*/pants.ini


.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/pants%/BUILD
$(CONFIGURED_BUILD_ROOT)/pants%/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/pants $(CONFIGURED_BUILD_ROOT)/pants$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
