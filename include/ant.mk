# Ant install instructions needed by both ant and buck

export ANT_IVY_DIR=$(CACHE_DIR)/ant_ivy
export ANT_HOME=$(ANT_IVY_DIR)/ant_ivy$(ANT_DEFAULT_VERSION)
export ANT=$(ANT_IVY_DIR)/ant_ivy$(ANT_DEFAULT_VERSION)/bin/ant

.PRECIOUS: $(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz
$(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz:
	@mkdir -p $(ANT_IVY_DIR)
	@cd $(ANT_IVY_DIR); wget --quiet http://archive.apache.org/dist/ant/binaries/apache-ant-$*-bin.tar.gz



.PRECIOUS: $(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_DEFAULT_VERSION).jar
$(ANT_IVY_DIR)/ant_home/lib/ivy-$(IVY_DEFAULT_VERSION).jar:
	@mkdir -p $(ANT_IVY_DIR)/ant_home/lib
	@cd $(ANT_IVY_DIR); wget --quiet http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist//ant/ivy/$(IVY_DEFAULT_VERSION)/apache-ivy-$(IVY_DEFAULT_VERSION)-bin.tar.gz
	@cd $(ANT_IVY_DIR); tar -xzf apache-ivy-$(IVY_DEFAULT_VERSION)-bin.tar.gz
	@cd $(ANT_IVY_DIR); cp apache-ivy-$(IVY_DEFAULT_VERSION)/ivy-$(IVY_DEFAULT_VERSION).jar ant_home/lib/


.PRECIOUS: $(ANT_IVY_DIR)/ant_ivy%/bin/ant
$(ANT_IVY_DIR)/ant_ivy%/bin/ant: $(ANT_IVY_DIR)/apache-ant-%-bin.tar.gz
	@mkdir -p $(ANT_IVY_DIR)/ant_ivy$*
	@cd $(ANT_IVY_DIR);tar -xzf apache-ant-$*-bin.tar.gz -C ant_ivy$* --strip-components 1
	touch $(ANT_IVY_DIR)/ant_ivy$*/bin/ant
