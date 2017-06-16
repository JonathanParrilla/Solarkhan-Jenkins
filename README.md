# Jenkins
A custom Jenkins image. I created it for SmartBear Software. It is used by several development teams for their Dev, Stage, Q/A, and Production environments.

It is comprised of a Dockerfile of a few other files used to configure and properly setup the Jenkins Docker Container.

This is based on the official Jenkins DockerFile. I simply removed all un-seen external dependencies and took complete control. This allows me to use different Operating Systems, set all environment variables, and control every aspect of my Jenkins Docker Container.

This also makes upgrading/updating safer as all dependencies are controlled via the dockerfile in this repo.
