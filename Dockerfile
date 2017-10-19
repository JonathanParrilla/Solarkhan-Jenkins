FROM ubuntu:14.04

MAINTAINER Jonathan Parrilla <jonathan.parrilla@smartbear.com>

# Debian:Jessie-Backports comes from Debian:Jessie, which in turn comes from an empty image.
# Debian:Jessie-Backports makes it easy to install Java.

# Set Debian Frontend to noninteractive (no prompts)
ENV DEBIAN_FRONTEND="noninteractive"

# Set the Jenkins Version
ENV JENKINS_VERSION="2.67"

# ===== Dependencies AND Jenkins =====

# ---------- Install Dependencies ----------
RUN apt-get update && apt-get -t jessie-backports install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    ca-certificates-java \
    curl \
    lxc \
    iptables \
    git \
    zip \
    supervisor \
    openjdk-8-jre-headless \
    daemon \
    net-tools \
    ssh \
    psmisc && \

    # ---------- Install Jenkins ----------
    curl -s -L -O http://pkg.jenkins-ci.org/debian/binary/jenkins_${JENKINS_VERSION}_all.deb && \
    dpkg -i jenkins_${JENKINS_VERSION}_all.deb && \
    rm -f jenkins_${JENKINS_VERSION}_all.deb && \
    
    # ----- Cleanup After Installations -----
    apt-get autoremove -yq --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# ========== DOCKER ==========

# Install Docker from Docker Inc. repositories
RUN curl -sSL https://get.docker.com/ | sh

# Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD https://raw.githubusercontent.com/docker/docker/master/hack/dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker


# ========== Configure Jenkins ==========

# Set JENKINS_HOME
ENV JENKINS_HOME="/var/lib/jenkins"

# Add user jenkins to docker group
RUN usermod -a -G docker jenkins

# Add Supervisord file to control startup.
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port used for Web Interface
EXPOSE 8080

# Expose port used for Slaves (if applicable)
EXPOSE 50000

# ===== SUDO =====
RUN apt-get install -y sudo-ldap

# ===== NODEJS and NPM =====
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# ===== CROSS BROWSER TESTING TUNNELS =====
RUN npm install -g -y cbt_tunnels

# ===== AWS CLI TOOLS =====

RUN apt-get install -y awscli

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
