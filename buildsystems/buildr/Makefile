.PHONY: default
default: buildr

export BUILDR_DIR=$(CACHE_DIR)/buildr

.PHONY: buildr
buildr: buildr$(BUILDR_VERSION)

.NOTPARALLEL: buildr%
.PHONY: buildr%
buildr%: $(CONFIGURED_BUILD_ROOT)/buildr/buildfile $(BUILDR_DIR)/gems/buildr-%/bin/buildr
	$(info ******* buildr start)
	cd $(CONFIGURED_BUILD_ROOT)/buildr; GEM_HOME=$(BUILDR_DIR) time $(BUILDR_DIR)/gems/buildr-$*/bin/buildr -q package


.PRECIOUS: $(BUILDR_DIR)/gems/buildr-%/bin/buildr
$(BUILDR_DIR)/gems/buildr-%/bin/buildr:
	@mkdir -p $(BUILDR_DIR)
	@GEM_HOME=$(BUILDR_DIR) gem install buildr -q -v $*
	@touch $(BUILDR_DIR)/gems/buildr-$*/bin/buildr

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/buildr/buildfile
$(CONFIGURED_BUILD_ROOT)/buildr/buildfile: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/buildr $(CONFIGURED_BUILD_ROOT)/buildr --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

