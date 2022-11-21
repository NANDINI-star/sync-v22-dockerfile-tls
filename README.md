# How to use this image
The simplest way to run Sync on Docker is:
```
$ docker run -d sync
```
Once started, the Sync Embedded Web Server will be listening on port 8080 insice the container, which should be reachable by visiting ```http://container-ip:8080``` in a browser. To expose Sync to outside requests, publish port 8080 to the host using a port mapping as follows:
```
$ docker run -p 81:8181 -d sync
```
This will map port 8181 inside the container to port 81 on the host. The application will then be reachable at ```http://host-ip```. 

It is also possible to configure the container to use TLS to host the web server. See [USE_TLS](#USE_TLS) for more details.
 
# Configuration
## Volume
You must mount a volume to store application data that must persist after the container is exited. To do this, you can run the container as follows:
```
$ docker run -v /sync:/var/opt/sync \
    -d sync
```
This will mount the /sync folder on the host to the /var/opt/sync folder in the container, which is the location configured for Application Directory inside the container. 

# Environment Variables
## USE_TLS
Default: False

If true, the container will attempt to start with TLS. The container will attempt to find the certificate to use at ```/opt/sync/certs/``` within the container, so for example, to use an ```Sync.pfx``` file with no password, the `docker run` command might look something like this:

```
docker run -e USE_TLS=true -v /Sync.pfx:/opt/sync/certs/Sync.pfx -p 443:8443 sync
```

## KeyStoreName
Default: Sync.pfx

The name of the certificate that the container will attempt to use at the ```/opt/sync/certs``` path.

## KeyStorePassword
Default:

The password for the certificate, if one is required.

## KeyStoreType
Default: PKCS12
Available Values: PKCS12, JKS, JCEKS

This defines the type of keystore the application should expect to find within ```/opt/sync/certs``` in order to host the web server with TLS.

## JAVA_OPTIONS
JVM options can be set by passing the JAVA_OPTIONS environment variable to the container. For example, to set the maximum heap size to 2 gigabytes, you can run the container as follows:
```
$ docker run -e JAVA_OPTIONS="-Xmx2g" \
    -d sync
```

## APP_DB
The application will use a Derby database for logging transaction data by default, but an external database like PostgreSQL, SQLServer, or MySQL may be used instead. This can be adjusted by setting the ```APP_DB``` environment variable, like so:
```
$ docker run -e APP_DB="jdbc:cdata:postgresql:Server=arc_db;Port=5432;Database=postgres;User=postgres;Password=mysecretpassword;" \
    -d sync
``` 