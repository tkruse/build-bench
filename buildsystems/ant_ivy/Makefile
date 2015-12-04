.PHONY: default
default: ant_ivy

export ANT_IVY_DIR=$(CACHE_DIR)/ant_ivy

.PHONY: ant_ivy
ant_ivy: ant_ivy$(ANT_VERSION)

.NOTPARALLEL: ant_ivy%
.PHONY: ant_ivy%
ant_ivy%: $(CONFIGURED_BUILD_ROOT)/ant_ivy/build.xml $(ANT_IVY_DIR)/ant_ivy%/bin/ant $(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_VERSION).jar
	$(info ******* ant-ivy start)
	cd $(CONFIGURED_BUILD_ROOT)/ant_ivy; IVY_HOME=$(ANT_IVY_DIR)/ant_home/ ANT_HOME=$(ANT_IVY_DIR)/ant_ivy% time $(ANT_IVY_DIR)/ant_ivy$*/bin/ant jar -q


.PRECIOUS: $(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz
$(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz:
	@mkdir -p $(ANT_IVY_DIR)
	@cd $(ANT_IVY_DIR); wget http://archive.apache.org/dist/ant/binaries/apache-ant-$*-bin.tar.gz

.PRECIOUS: $(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_VERSION).jar
$(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_VERSION).jar:
	@mkdir -p $(ANT_IVY_DIR)/ant_home/lib
	@cd $(ANT_IVY_DIR); wget http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist//ant/ivy/$(IVY_VERSION)/apache-ivy-$(IVY_VERSION)-bin.tar.gz
	@cd $(ANT_IVY_DIR); tar -xzvf apache-ivy-$(IVY_VERSION)-bin.tar.gz
	@cd $(ANT_IVY_DIR); cp apache-ivy-$(IVY_VERSION)/ivy-$(IVY_VERSION).jar ant_home/lib/


.PRECIOUS: $(ANT_IVY_DIR)/ant_ivy%/bin/ant
$(ANT_IVY_DIR)/ant_ivy%/bin/ant: $(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz
	@mkdir -p $(ANT_IVY_DIR)/ant_ivy$*
	@cd $(ANT_IVY_DIR);tar -xzvf apache-ant-$*-bin.tar.gz -C ant_ivy$* --strip-components 1
	touch $(ANT_IVY_DIR)/ant_ivy$*/bin/ant


.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/ant_ivy/build.xml
$(CONFIGURED_BUILD_ROOT)/ant_ivy/build.xml: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/ant_ivy $(CONFIGURED_BUILD_ROOT)/ant_ivy --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

