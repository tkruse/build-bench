# Definition of buildfiles
export BUILD_DEFINITIONS=multiModule
# Definition of source files
export SOURCE_PROJECT=multi
# Configuration for template-based sources
export FILE_NUM=20
export SUBPROJECT_NUM=8
# Name of the benchmark, used for folder and report
export TARGET_NAME=$(SOURCE_PROJECT)-$(SUBPROJECT_NUM)-$(FILE_NUM)

# must use lein-sub in contrast to default leiningen
export BUILDSYSTEMS=\
gradle \
maven \
buildr \
ant_ivy \
buck \
lein-sub \
sbt \
bazel \
pants
