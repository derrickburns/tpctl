FROM strimzi/kafka:0.18.0-kafka-2.5.0
USER root

RUN yum -q -y install unzip
RUN mkdir -p /opt/kafka/plugins/debezium-connector-mongodb

RUN curl -sL "https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/1.2.0.Final/debezium-connector-mongodb-1.2.0.Final-plugin.tar.gz" | tar xz -C /tmp && cp -r /tmp/debezium-connector-mongodb/* /opt/kafka/plugins/debezium-connector-mongodb/

RUN curl -sl "https://archive.apache.org/dist/groovy/3.0.5/distribution/apache-groovy-binary-3.0.5.zip" --output /tmp/groovy-3.0.5.zip && unzip -q /tmp/groovy-3.0.5.zip -d /tmp && cp /tmp/groovy-3.0.5/lib/groovy-3.0.5.jar /opt/kafka/libs

#RUN curl -sL "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz" | tar xz -C /tmp && cp -r /tmp/graalvm-ce-java11-20.1.0/lib/graalvm/* /opt/kafka/plugins/debezium-connector-mongodb/

RUN chown -R 1001 /opt/kafka/plugins
USER 1001
