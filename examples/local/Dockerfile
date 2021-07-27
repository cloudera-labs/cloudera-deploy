FROM centos/systemd
RUN yum install -y openssh-server sudo && \
  systemctl enable sshd.service
COPY --chmod=0600 id_rsa /root/.ssh/id_rsa
COPY --chmod=0600 id_rsa.pub /root/.ssh/authorized_keys
