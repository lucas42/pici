FROM docker:dind

WORKDIR /usr/src/app

RUN apk --update add curl bash openssh git
RUN apk add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install docker-compose

RUN echo -e "#!/bin/bash\nset -e\nssh-keygen -A\n/usr/sbin/sshd\ndockerd-entrypoint.sh" > start.sh

ENV USER=docker-deploy
RUN addgroup docker
RUN adduser -D $USER -G docker
RUN passwd -u $USER
RUN mkdir -m 755 /home/$USER/.ssh/
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYt5KA+HeY45JzwwF0hl/+9Zdgp/9z04WKAEYcIw+LwPCn1LuqId2IF69WlU+hfbtZBWgsYmajORQKRLqa2IuHh3AdqKzG03XxlTWOjqZdMuz1aRnCkLfmXuLHUbddUxEgpUqpBNShv7bNl4VtauSB0N6yo/2nqOVol0dXGFLrq5UVtiFH4HrgIrJiT83MupJvmZ+VnkYNXM/9PQVjHNESxsJdNJNbiW2oFPervAXpcypXPLYVS0Hdbyx76JEpL5xl4J9aZ6FZwSQZNcjLxG4vCklp2YGgdYo9XWf384JaSnauw9IlqxVcTlIFYJVPEttYS2j39YNxMdnGAB96xuUn $USER" > /home/$USER/.ssh/authorized_keys

COPY quickbuild.sh /usr/local/bin/quickbuild.sh

EXPOSE 22
CMD ["bash", "start.sh"]