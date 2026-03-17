FROM docker:27.4.1-dind

WORKDIR /usr/src/app

RUN apk --update add curl bash openssh openssh-client git busybox-extras

RUN echo -e "#!/bin/bash\nset -e\nssh-keygen -A\ncrond\n/usr/sbin/sshd\ndockerd-entrypoint.sh" > start.sh

# Prune dangling Docker images daily to prevent unbounded volume growth
RUN echo "0 3 * * * docker image prune -f >> /var/log/docker-prune.log 2>&1" > /etc/crontabs/root

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