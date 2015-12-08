
export TIME_CACHE_DIR=$(CACHE_DIR)/time
export TIME_VERSION=1.7
export TIME_DIR=$(TIME_CACHE_DIR)/time$(TIME_VERSION)
export TIME=$(TIME_DIR)/bin/time

export REPORTS_FORMAT:=%e,%U,%S,%I,%K,%O,%W,%r,%C
export REPORTS_DIR=$(BUILD_DIR)/reports

define TIME_CMD
$(TIME) -o $(REPORTS_DIR)/$(TARGET_NAME).csv -a -f'$1,$(REPORTS_FORMAT)'
endef

.PRECIOUS: $(REPORTS_DIR)/%
$(REPORTS_DIR)/%:
	@mkdir -p $@

.PRECIOUS: $(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz
$(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz:
	@mkdir -p $(TIME_CACHE_DIR)
	@cd $(TIME_CACHE_DIR); wget http://ftp.gnu.org/pub/gnu/time/time-$(TIME_VERSION).tar.gz

.PRECIOUS: $(TIME)
$(TIME): $(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz
	cd $(TIME_CACHE_DIR);tar -xzf time-1.7.tar.gz
	cd $(TIME_CACHE_DIR)/time-1.7; ./configure --quiet --prefix=$(TIME_DIR)
	cd $(TIME_CACHE_DIR)/time-1.7; make install -j2
#	ln -s `pwd`/time /usr/local/bin/time
