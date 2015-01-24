name := "sbt-example"

organization := "com.example"

version := "1.0.0-SNAPSHOT"

scalacOptions += "-target:jvm-1.7"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "1.9.2" % "test",
  "com.novocode" % "junit-interface" % "0.10" % "test->default"
)
