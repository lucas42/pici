FROM docker:27.4.1-dind

WORKDIR /usr/src/app

RUN apk --update add curl bash openssh git docker-compose

RUN echo -e "#!/bin/bash\nset -e\nssh-keygen -A\n/usr/sbin/sshd\ndockerd-entrypoint.sh" > start.sh

# Workaround for "error creating overlay mount" error
RUN mkdir -p /etc/docker
RUN echo '{"max-concurrent-uploads": 1}' > /etc/docker/daemon.json

ENV USER=docker-deploy
RUN adduser -D $USER -G docker
RUN passwd -u $USER
RUN mkdir -m 755 /home/$USER/.ssh/
COPY authorized_keys authorized_keys
RUN mv authorized_keys /home/$USER/.ssh/authorized_keys
RUN ssh-keyscan -H github.com >> /home/$USER/.ssh/known_hosts
RUN chown $USER /home/$USER/.ssh/known_hosts
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

COPY quickbuild.sh /usr/bin/quickbuild.sh

EXPOSE 22
CMD ["bash", "start.sh"]