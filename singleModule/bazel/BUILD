
java_library(
    name = "commons-math",
    srcs = glob(["src/main/java/**/*.java"]),
    resources = glob(["src/main/resources/**/*.*"]),
)

java_library(
    name = "test_helpers",
    srcs = glob(
        ["src/test/java/**/*.java"]
    ),
    resources = glob(["src/test/resources/**/*.*"]),
    deps = [
        ':commons-math',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)

java_test(
    name = "commons-math-tests",
    srcs = glob(["src/test/java/**/*Test.java"],
        exclude = ["src/test/java/**/*Abstract*Test.java"]),
    size='medium',
    deps = [
        ':commons-math',
        ':test_helpers',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)
