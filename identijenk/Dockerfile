FROM jenkins/jenkins
USER root
RUN  apt-get update \
	&& apt-get install -y apt-transport-https \
	&& apt-get install -y sudo \
	&& apt-get install -y docker.io \
	&& apt-get install -y docker-compose \ 
	&& rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/plugins.txt
