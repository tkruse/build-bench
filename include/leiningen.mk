export LEININGEN_DIR=$(CACHE_DIR)/leiningen

.PRECIOUS: $(LEININGEN_DIR)/leiningen-%-standalone.zip
$(LEININGEN_DIR)/leiningen-%-standalone.zip:
	@mkdir -p $(LEININGEN_DIR)
	@cd $(LEININGEN_DIR); wget https://github.com/technomancy/leiningen/releases/download/$*/leiningen-$*-standalone.zip

.PRECIOUS: $(LEININGEN_DIR)/leiningen%/lein
$(LEININGEN_DIR)/leiningen%/lein:
	@mkdir -p $(LEININGEN_DIR)/leiningen$*
	@cd $(LEININGEN_DIR)/leiningen$*; wget https://raw.githubusercontent.com/technomancy/leiningen/$*/bin/lein
	@chmod u+x $(LEININGEN_DIR)/leiningen$*/lein
