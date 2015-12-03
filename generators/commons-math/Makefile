.PHONY: default
default: $(CONFIGURED_BUILD_SOURCE)

$(CONFIGURED_BUILD_SOURCE): $(CACHE_DIR)/commons-math
	@mkdir -p $(CONFIGURED_BUILD_SOURCE)
# softlinking causes problems with some tools (pants)
	cp -rf $(CACHE_DIR)/commons-math/* $(CONFIGURED_BUILD_SOURCE)

# Apache commons math sources
# needed some cleaning up to prevent test failures in diverse buildsystems
$(CACHE_DIR)/commons-math:
	@mkdir -p $(CACHE_DIR)
	cd $(CACHE_DIR); git clone https://git-wip-us.apache.org/repos/asf/commons-math.git; cd commons-math; git checkout MATH_3_4
# Sadly this test fails with buck because java.io.File cannot handle uris inside jars.
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/random/EmpiricalDistributionTest.java
# This test fails with with buck for unknown reasons of comparing floating points to zero.
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/ml/neuralnet/sofm/KohonenUpdateActionTest.java
# Some actual Tests sadly do not end with Test.java, so for fairness sake they cannot be used
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/fitting/leastsquares/EvaluationTestValidation.java
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestBinary.java
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/genetics/GeneticAlgorithmTestPermutations.java
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/optim/nonlinear/vector/jacobian/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/optimization/general/AbstractLeastSquaresOptimizerTestValidation.java
	rm -f $(CACHE_DIR)/commons-math/src/test/java/org/apache/commons/math3/util/FastMathTestPerformance.java
	mv $(CACHE_DIR)/commons-math/pom.xml $(CACHE_DIR)/commons-math/pom.xml.bak
	mv $(CACHE_DIR)/commons-math/build.xml $(CACHE_DIR)/commons-math/build.xml.bak
