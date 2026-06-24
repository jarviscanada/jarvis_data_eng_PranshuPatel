FROM eclipse-temurin:8-jre-alpine
COPY target/*-shaded.jar /usr/local/app/grep/lib/grep.jar
ENTRYPOINT ["java","-jar","/usr/local/app/grep/lib/grep.jar"]
