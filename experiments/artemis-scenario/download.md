We need to get an artemis download but for now I do not have a way to detect the
latest version and get that. You could change the following command to get the latest if
you know which one it is.

``wget -O apache-artemis-2.6.2-bin.tar.gz "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=activemq/activemq-artemis/2.6.2/apache-artemis-2.6.2-bin.tar.gz"``{{execute}}

We can now expand the zip file

``tar xf apache-artemis-2.6.2-bin.tar.gz``{{execute}}

And now we should have the exploded folder with artemis within

``ls -l``{{execute}}

Finally we can now set the environment variable to point to ARTEMIS

``export ARTEMIS_HOME=`pwd`/apache-artemis-2.6.2``{{execute}}

We will now create a broker instance in the next step