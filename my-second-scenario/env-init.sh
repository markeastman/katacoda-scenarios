git clone https://github.com/markeastman/katacoda-scenarios/my-first-scenario
docker build -t webserver-image:v1
docker run -d -p 80:80 webserver-image:v1
