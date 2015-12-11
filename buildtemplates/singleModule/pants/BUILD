java_library(name='lib',
  sources = rglobs('src/main/java/*.java'),
  resources = [
    'src/main/resources'
  ],
)

junit_tests(name='test',
  sources = rglobs('src/test/java/*.java'),
  dependencies = [
    '3rdparty:junit',
    ':lib',
  ],
  resources = [
    'src/test/resources'
  ],
 )
