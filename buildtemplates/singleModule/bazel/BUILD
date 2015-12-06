
java_library(
    name = "example",
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
        ':example',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)

java_test(
    name = "example-tests",
    srcs = glob(["src/test/java/**/*Test.java"],
        exclude = ["src/test/java/**/*Abstract*Test.java"]),
    size='small',
    # this may cause warnings for short tests
    timeout='eternal',
    deps = [
        ':example',
        ':test_helpers',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)
