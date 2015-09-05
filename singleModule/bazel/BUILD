
java_library(
    name = "commons-math",
    srcs = glob(["src/main/java/**/*.java"])
)

java_library(
    name = "test_helpers",
    srcs = glob(
        ["src/test/java/**/*.java"],
        exclude = ["src/test/java/**/*Test.java"]
    ),
    deps = [
        ':commons-math',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)

java_test(
    name = "commons-math-tests",
    srcs = glob(["src/test/java/**/*Test.java"]),
    deps = [
        ':commons-math',
        ':test_helpers',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)
