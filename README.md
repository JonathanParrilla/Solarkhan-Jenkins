# Solarkhan Jenkins
A custom Jenkins image.

It is comprised of a Dockerfile of a few other files used to configure and properly setup the Jenkins Docker Container.

This is based on the official Jenkins for Docker, as well as killercentury/jenkins-dind. I simply removed all un-seen external dependencies and took complete control. This allows me to use different Operating Systems, set all environment variables, and control every aspect of my Jenkins Docker Container.

The dind file is used to make sure Docker can be used within the Jenkins Container. It is added to the image as it is built.
The file inside this repo is a backup in case the original ever disappears.

The supervisord file determines the start order of services. It is added to the image as it is built.

The dockerfile builds the image itself (duh!) and includes the dind and supervisord files already.

This also makes upgrading/updating safer as all dependencies are controlled via the dockerfile in this repo.

To build:
Have all three files in the same folder. 
Run Docker Build -t MY-NEW-IMAGE .


