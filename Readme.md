# TEI publisher
This is a dockerized version of the [TEI publisher](https://teipublisher.com/). Its based on the official exist-db image and contains the tei-publisher-lib and tei-publisher-app. 

## Usage
You can start the container with [docker](https://www.docker.com/) or [podman](https://podman.io/)
```bash
docker run --rm -p 8080:8080 tobinski/tei-publisher
```
Then you can access tei-publisher over [localhost:8080/exist/apps/tei-publisher](http://localhost:8080/exist/apps/tei-publisher/)

## Data
If you wanna work persistently with your data its recommended to mount a directory to store the DB-files
```bash
docker run -p 8080:8080 -v $(pwd)/data:/exist-data/ --name tei-publisher tobinski/tei-publisher
```

