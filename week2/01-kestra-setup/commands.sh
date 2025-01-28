docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kesta/kestra:latest server local

## Kestra in DockerHub
https://hub.docker.com/r/kestra/kestra/tags