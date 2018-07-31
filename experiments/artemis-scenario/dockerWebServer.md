To test the broker we will now run a webser within a docker image to isolate it 
from the broker host and then use this to view some html pages that contain javascript
examples of consumers and producers of messages.

``docker build -t webserver-image:v1 .``{{execute}}
``docker run -d -p 80:80 webserver-image:v1``{{execute}}
