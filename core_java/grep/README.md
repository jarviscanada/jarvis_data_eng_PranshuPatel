---

# Introduction

This project implements a simplified version of the Unix `grep` command using Core Java. The application recursively scans files from a given root directory, matches lines using a regular expression, and writes matched results to an output file.

The project was built using **Java 8**, **Maven**, **SLF4J + Log4j**, **Lambda & Stream APIs**, and **Docker**. The application is packaged as a fat jar using the Maven Shade Plugin and containerized for easy distribution.

---

# Quick Start

## 1 Build the project

```bash
cd core_java/grep
mvn clean package
```

## 2 Run using fat jar

```bash
java -jar target/grep-1.0-SNAPSHOT.jar ".*Romeo.*Juliet.*" ./data ./out/grep.txt
```

## 3 Run using Docker

```bash
docker pull itspranshupatel/grep

docker run --rm \
-v "$(pwd)/data:/data" \
-v "$(pwd)/log:/log" \
itspranshupatel/grep ".*Romeo.*Juliet.*" /data /log/grep.out
```

---

# Implementation

## Pseudocode (process method)

```
matchedLines = empty list

for each file in listFiles(rootPath):
    for each line in readLines(file):
        if containsPattern(line):
            matchedLines.add(line)

writeToFile(matchedLines)
```

The `process()` method acts as a high-level workflow controller.
Helper methods handle file listing, reading, filtering, and writing.

---

## Performance Issue

The initial implementation stored all file lines in memory using `List<String>`, which may cause `OutOfMemoryError` when processing large datasets.

To fix this, we can:

* Use `BufferedReader` to read line-by-line.
* Return `Stream<String>` instead of `List<String>` for lazy evaluation.
* Process and write matching lines immediately instead of storing all in memory.

This allows processing files larger than heap size.

---

# Test

Manual testing steps:

1. Prepared sample text files inside `./data` directory.
2. Ran multiple regex test cases:

   * `".*Romeo.*Juliet.*"`
   * `"^Enter.*"`
   * `"^$"` (empty line test)
3. Verified:

   * Output file was created.
   * Matched lines were correct.
   * Logs were properly printed via SLF4J.
4. Tested both:

   * `java -jar`
   * `docker run`

Results were compared against expected grep behavior.

---

# Deployment

The application was dockerized using:

* `eclipse-temurin:8-jre-alpine` base image
* Fat jar built via Maven Shade Plugin
* ENTRYPOINT configured to execute the jar

Dockerfile:

```
FROM eclipse-temurin:8-jre-alpine
COPY target/grep-1.0-SNAPSHOT.jar /usr/local/app/grep/lib/grep.jar
ENTRYPOINT ["java","-jar","/usr/local/app/grep/lib/grep.jar"]
```

The image was pushed to Docker Hub:

```
itspranshupatel/grep
```

This allows users to run the app without installing Java or Maven.

---

# Improvement

1. Replace List-based processing with Stream-based lazy processing for better memory efficiency.
2. Add JUnit test coverage instead of relying only on manual testing.
3. Improve performance by parallelizing file processing using parallel streams.
4. Add better CLI argument validation and error handling.
5. Implement configurable logging levels.

---
