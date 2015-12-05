
export TIME_CACHE_DIR=$(CACHE_DIR)/time
export TIME_VERSION=1.7
export TIME_DIR=$(TIME_CACHE_DIR)/time$(TIME_VERSION)
export TIME=$(TIME_DIR)/bin/time

.PRECIOUS: $(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz
$(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz:
	@mkdir -p $(TIME_CACHE_DIR)
	@cd $(TIME_CACHE_DIR); wget http://ftp.gnu.org/pub/gnu/time/time-$(TIME_VERSION).tar.gz

.PRECIOUS: $(TIME)
$(TIME): $(TIME_CACHE_DIR)/time-$(TIME_VERSION).tar.gz
	cd $(TIME_CACHE_DIR);tar -xzf time-1.7.tar.gz
	cd $(TIME_CACHE_DIR)/time-1.7; ./configure --prefix=$(TIME_DIR)
	cd $(TIME_CACHE_DIR)/time-1.7; make install -j2
#	ln -s `pwd`/time /usr/local/bin/time
