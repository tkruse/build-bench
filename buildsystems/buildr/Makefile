# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: default
default: buildr

include ../../include/time.mk

export BUILDR_DIR=$(CACHE_DIR)/buildr

.PHONY: buildr
buildr: buildr$(BUILDR_DEFAULT_VERSION)

.PHONY: version
version: $(BUILDR_DIR)/gems/buildr-$(BUILDR_DEFAULT_VERSION)/bin/buildr
	GEM_HOME=$(BUILDR_DIR) $(BUILDR_DIR)/gems/buildr-$(BUILDR_DEFAULT_VERSION)/bin/buildr --version

.NOTPARALLEL: buildr%
.PHONY: buildr%
buildr%: $(CONFIGURED_BUILD_ROOT)/buildr%/buildfile $(BUILDR_DIR)/gems/buildr-%/bin/buildr $(TIME)
	$(info ******* buildr start)
	cd $(CONFIGURED_BUILD_ROOT)/buildr$*; GEM_HOME=$(BUILDR_DIR) $(TIME) $(BUILDR_DIR)/gems/buildr-$*/bin/buildr -q package


.PRECIOUS: $(BUILDR_DIR)/gems/buildr-%/bin/buildr
$(BUILDR_DIR)/gems/buildr-%/bin/buildr:
	@mkdir -p $(BUILDR_DIR)
	@GEM_HOME=$(BUILDR_DIR) gem install buildr -q -v $*
	@touch $(BUILDR_DIR)/gems/buildr-$*/bin/buildr

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/buildr%/buildfile
$(CONFIGURED_BUILD_ROOT)/buildr%/buildfile: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/buildr $(CONFIGURED_BUILD_ROOT)/buildr$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

