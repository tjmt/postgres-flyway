FROM postgres:9.4

ARG FLYWAY_VERSION=5.1.4

# Install OpenJDK-8
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y ca-certificates-java
RUN apt-get install -y ant
RUN apt-get install -y curl
RUN apt-get clean
RUN update-ca-certificates -f

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install Flyway
RUN mkdir /flyway \
  && cd /flyway \
  && curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz --strip-components=1 \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && ln -s /flyway/flyway /usr/local/bin/flyway

  
# COPY ./sql /flyway/sql

ENTRYPOINT sh -c "until (docker-entrypoint.sh postgres); do sleep 1; done & until (flyway info -user='${POSTGRES_USER}' -password='${POSTGRES_PASSWORD}' -url='jdbc:postgresql://localhost:5432/${POSTGRES_DB}'); do sleep 10; done; flyway migrate -user='${POSTGRES_USER}' -password='${POSTGRES_PASSWORD}' -url='jdbc:postgresql://localhost:5432/${POSTGRES_DB}'; flyway info -user='${POSTGRES_USER}' -password='${POSTGRES_PASSWORD}' -url='jdbc:postgresql://localhost:5432/${POSTGRES_DB}'; wait"
