FROM mcr.microsoft.com/openjdk/jdk:11-ubuntu

# copy required files and fix permissions
RUN mkdir -p /opt/sync/webapp
WORKDIR /opt/sync

COPY sync.jar sync.jar
COPY webapp/sync.war webapp/sync.war
COPY sync.properties /opt/sync/

RUN addgroup --system --gid 20000 cdatasync \
    && adduser --system --uid 20000 --gid 20000 cdatasync \
    && mkdir -p /var/opt/sync \
    && chown -R cdatasync:cdatasync /var/opt/sync \
    && chown -R cdatasync:cdatasync /opt/sync

# change user and set environment
USER cdatasync
ENV APP_DIRECTORY=/var/opt/sync

EXPOSE 8181

# run the app
CMD ["java","-jar","sync.jar"]