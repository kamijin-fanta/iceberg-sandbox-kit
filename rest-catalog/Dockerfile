FROM tabulario/iceberg-rest:0.6.0

ENV URL=https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar
ADD --chown=iceberg:iceberg ${URL} /usr/lib/iceberg-rest/

CMD ["java", "-classpath", "/usr/lib/iceberg-rest/*", "org.apache.iceberg.rest.RESTCatalogServer"]
