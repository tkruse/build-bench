# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: default
default: ant_ivy

include ../../include/time.mk
include ../../include/ant.mk

.PHONY: ant_ivy
ant_ivy: ant_ivy$(ANT_DEFAULT_VERSION)

.PHONY: version
version: $(ANT_IVY_DIR)/ant_ivy$(ANT_DEFAULT_VERSION)/bin/ant
	$(ANT_IVY_DIR)/ant_ivy$(ANT_DEFAULT_VERSION)/bin/ant -version

.NOTPARALLEL: ant_ivy%
.PHONY: ant_ivy%
ant_ivy%: $(CONFIGURED_BUILD_ROOT)/ant_ivy%/build.xml $(ANT_IVY_DIR)/ant_ivy%/bin/ant $(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_DEFAULT_VERSION).jar $(TIME)
	$(info ******* ant-ivy start)
	cd $(CONFIGURED_BUILD_ROOT)/ant_ivy$*; IVY_HOME=$(ANT_IVY_DIR)/ant_home/ ANT_HOME=$(ANT_IVY_DIR)/ant_ivy$* $(TIME) $(ANT_IVY_DIR)/ant_ivy$*/bin/ant jar -q



.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/ant_ivy%/build.xml
$(CONFIGURED_BUILD_ROOT)/ant_ivy%/build.xml: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/ant_ivy $(CONFIGURED_BUILD_ROOT)/ant_ivy$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

