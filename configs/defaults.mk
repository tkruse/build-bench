# This file is loaded before the one given via CONFIG

## Customization variables
## Change these as you need in your config

export JAVA_HOME=/usr/lib/jvm/java-8-oracle/

# delete undesired buildsystems in custom config
export BUILDSYSTEMS=\
gradle \
maven \
buildr \
ant_ivy \
buck \
leiningen \
sbt \
bazel \
pants

export DEFAULT_CONFIG=configs/generated_single.mk

# for jinja2 templates
export FILE_NUM=0
export SUBPROJECT_NUM=0


## Build orchestration variables
## Should usually be left alone

# only works when running make in root folder :-(
export ROOT_DIR=$(shell pwd)

# where generated sources go and buildsystems are invoked
export BUILD_DIR=$(ROOT_DIR)/build

export RESULTS_DIR=$(BUILD_DIR)/results

# folder containing source resources except for buildfiles
export DOWNLOAD_SOURCES_DIR=$(BUILD_DIR)/buildsrc
export TEMPLATES_DIR=$(ROOT_DIR)/generators
export BUILDSYSTEMS_DIR=$(ROOT_DIR)/buildsystems
export BUILDTEMPLATES_DIR=$(ROOT_DIR)/buildtemplates

# Makefile snippets
export INCLUDE_DIR=$(ROOT_DIR)/include

# Python helpers
export SCRIPTS_DIR=$(ROOT_DIR)/scripts
# location to drop anything not to be cleaned by "make clean"
export CACHE_DIR=$(ROOT_DIR)/caches

export CONFIGURED_BUILD_ROOT=$(BUILD_DIR)/$(SOURCE_PROJECT)
export CONFIGURED_BUILD_SOURCE=$(CONFIGURED_BUILD_ROOT)/source
