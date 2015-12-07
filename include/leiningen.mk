export LEININGEN_DIR=$(CACHE_DIR)/leiningen


.PRECIOUS: $(LEININGEN_DIR)/leiningen%/lein
$(LEININGEN_DIR)/leiningen%/lein:
	@mkdir -p $(LEININGEN_DIR)/leiningen$*
	@cd $(LEININGEN_DIR)/leiningen$*; wget --quiet https://raw.githubusercontent.com/technomancy/leiningen/$*/bin/lein
	@chmod u+x $(LEININGEN_DIR)/leiningen$*/lein
