(defproject org.example/sample "1.0.0-SNAPSHOT" ; version "1.0.0-SNAPSHOT"
  :description "A sample project"
  :url "http://example.org/sample-clojure-project"
  :min-lein-version "2.0.0"
  :profiles {:dev {:dependencies [[junit/junit "4.11"]]}}
  :dependencies [[org.clojure/clojure "1.7.0"] [junit/junit "4.11"]]
  :pedantic? :abort
  :plugins [[lein-junit "1.1.8"]]
  :repositories [["java.net" "http://download.java.net/maven/2"]]
  :update :never
  :checksum :fail
  :source-paths ["src/main/clojure"]
  :java-source-paths ["src/main/java" "src/test/java"]  ; Java source is stored separately.
  :test-paths ["src/test/clojure"]
  :junit ["src/test/java"]
  ;; regex magic to include all *Test.java, but no *AbstractTest.java
  :junit-test-file-pattern #"^((?!Abstract).)*Test.java$"
  :resource-paths ["src/test/resources" "src/main/resources"] ; Non-code files included in classpath/jar.
  :target-path "target/%s/"
  :clean-targets [:target-path :compile-path "out"]
  ;;; Jar Output
  ;; Name of the jar file produced. Will be placed inside :target-path.
  ;; Including %s will splice the project version into the filename.
  :jar-name "leiningen-example.jar"
  :auto-clean false)
