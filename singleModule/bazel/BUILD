
java_library(
    name = "commons-math",
    srcs = glob(["src/main/java/**/*.java"])
)

java_test(
    name = "commons-math-tests",
    srcs = glob(["src/test/java/**/*.java"]),
    deps = [
        ':commons-math',
        '@junit//jar',
        '@hamcrest-all//jar',
    ],
)
