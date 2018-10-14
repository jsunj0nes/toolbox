FROM fedora:28
ENTRYPOINT ["bash"]
WORKDIR /root
RUN rm *

ENV HELM_VERSION v2.11.0
ENV KUBECTL_VERSION v1.10.7
ENV DOCKER_VERSION 18.05.0

ENV GOBIN /usr/local/bin
ENV GOPATH /opt/go

RUN dnf --refresh --assumeyes install bats file findutils git golang gpg hostname iputils jq make nmap-ncat procps psmisc sysstat telnet which bind-utils tcpdump
RUN go get github.com/crosbymichael/slex
RUN pip install pyyaml

RUN curl -LO https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION-ce.tgz && \
      tar xfvz docker-$DOCKER_VERSION-ce.tgz && mv docker/docker /usr/local/bin && \
      rm -r docker-$DOCKER_VERSION-ce.tgz docker && \
    curl -LO https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz && \
      tar xfvz helm-$HELM_VERSION-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin && \
      rm -r helm-$HELM_VERSION-linux-amd64.tar.gz linux-amd64 && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
      chmod +x kubectl && mv kubectl /usr/local/bin

COPY tools/* /usr/local/bin/

RUN echo "export ETCDCTL_API=3" >> .bash_profile && \
    echo "alias etcd-health='etcdctl endpoint health'" >> .bash_profile && \
    echo "alias etcd-status='etcdctl endpoint status -w table'" >> .bash_profile && \
    echo "export ETCDCTL_CACERT=/media/root/etc/ssl/etcd/etcd-client-ca.crt" >> .bash_profile && \
    echo "export ETCDCTL_CERT=/media/root/etc/ssl/etcd/etcd-client.crt" >> .bash_profile && \
    echo "export ETCDCTL_KEY=/media/root/etc/ssl/etcd/etcd-client.key" >> .bash_profile && \
    echo "export SSH_AUTH_SOCK=~/.ssh.agent.sock" >> .bash_profile && \
    echo "configure" >> .bash_profile
