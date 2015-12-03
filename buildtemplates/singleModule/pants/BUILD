
target(name='lib',
  dependencies = [
    ':example-lib'
  ],
)

target(name='test',
  dependencies = [
    ':example-test'
  ],
)

java_library(name='example-lib',
  sources = rglobs('src/main/java/*.java'),
  resources = [
    'src/main/resources:resources'
  ],
)

resources(name='resources',
  sources = rglobs('src/test/resources/*'),
  dependencies = [],
)


java_library(name='example-test-lib',
  sources = rglobs('src/test/java/*.java'),
  resources = [
    'src/test/resources:resources'
    #':resources'
  ],
  dependencies = [
    ':example-lib',
    '3rdparty:junit'
  ],
)


junit_tests(name='example-test',
  sources = rglobs('src/test/java/*.java'),
  dependencies = [
    ':example-test-lib'
   ],
 )
