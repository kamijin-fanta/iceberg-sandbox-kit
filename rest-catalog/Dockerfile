FROM apache/iceberg-rest-fixture:1.8.1

ENV URL=https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.2.0/mysql-connector-j-9.2.0.jar
ADD --chown=iceberg:iceberg ${URL} /usr/lib/iceberg-rest/

CMD ["java", "-classpath", "/usr/lib/iceberg-rest/*", "org.apache.iceberg.rest.RESTCatalogServer"]
