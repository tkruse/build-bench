# This file is loaded before the one given via CONFIG

## Customization variables
## Change these as you need in your config

ifndef ROOT_DIR
$(error ROOT_DIR is not set)
endif

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

export DEFAULT_CONFIG=$(ROOT_DIR)/configs/generated_minimal.mk

# for jinja2 templates
export FILE_NUM=0
export SUBPROJECT_NUM=0

export ANT_DEFAULT_VERSION=1.9.6
export IVY_DEFAULT_VERSION=2.4.0
export MAVEN_DEFAULT_VERSION=3.3.9
export GRADLE_DEFAULT_VERSION=2.10
export BUILDR_DEFAULT_VERSION=1.4.23
# git repository tag
export BUCK_DEFAULT_VERSION=v2015.12.28.01
export LEININGEN_DEFAULT_VERSION=2.5.3
export SBT_DEFAULT_VERSION=0.13.9
# pants is horrible at backwards compatibility, expect problems when upgrading
export PANTS_DEFAULT_VERSION=0.0.70
export BAZEL_DEFAULT_VERSION=0.1.4rc2

## Build orchestration variables
## Should usually be left alone


# where generated sources go and buildsystems are invoked
export BUILD_DIR=$(ROOT_DIR)/build

export RESULTS_DIR=$(BUILD_DIR)/results

# folder containing source resources except for buildfiles
export GENERATED_SOURCES_DIR=$(BUILD_DIR)/buildsrc
export TEMPLATES_DIR=$(ROOT_DIR)/generators
export BUILDSYSTEMS_DIR=$(ROOT_DIR)/buildsystems
export BUILDTEMPLATES_DIR=$(ROOT_DIR)/buildtemplates


# Python helpers
export SCRIPTS_DIR=$(ROOT_DIR)/scripts
# location to drop anything not to be cleaned by "make clean"
export CACHE_DIR=$(ROOT_DIR)/caches

# TARGET_NAME will be defined later...
export CONFIGURED_BUILD_ROOT=$(BUILD_DIR)/$(TARGET_NAME)
export CONFIGURED_BUILD_SOURCE=$(CONFIGURED_BUILD_ROOT)/source
