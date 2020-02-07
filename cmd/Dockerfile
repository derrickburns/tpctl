FROM ubuntu:18.04 
WORKDIR /root/workdir
ENV TERM xterm-256color
ENV TZ America/Los_Angeles
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y && apt upgrade -y && \
    apt install nano python3-pip curl git openjdk-8-jdk vim python3 build-essential file locales jq expect -y && \
    pip3 install --upgrade --user awscli boto3 environs
RUN locale-gen en_US.UTF-8
RUN curl -sL https://github.com/google/jsonnet/releases/download/v0.14.0/jsonnet-bin-v0.14.0-linux.tar.gz | tar xz -C /tmp && \ 
    mv /tmp/jsonnet /usr/local/bin
RUN curl -sL "https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz" | tar xz -C /tmp && mv /tmp/linux-amd64/helm /usr/local/bin
RUN curl -sL "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin
RUN curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    mv /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    mv /opt/kubectx/kubens /usr/local/bin/kubens && \
    rm -rf /opt/kubectx
RUN curl -sL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 
RUN curl -sL -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    curl -sL -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator.sha256 && \
    openssl sha1 -sha256 /usr/local/bin/aws-iam-authenticator && \
    rm ./aws-iam-authenticator.sha256
RUN curl -sL -o /usr/local/bin/fluxctl https://github.com/fluxcd/flux/releases/download/1.18.0/fluxctl_linux_amd64
RUN mv ~/.local/bin/* /usr/local/bin
RUN curl -sL -o /usr/local/bin/linkerd https://github.com/linkerd/linkerd2/releases/download/stable-2.7.0/linkerd2-cli-stable-2.7.0-linux 
RUN curl -sL -o /usr/local/bin/glooctl https://github.com/solo-io/gloo/releases/download/v1.3.3/glooctl-linux-amd64
RUN curl -sL /usr/local/bin/hub https://github.com/github/hub/releases/download/v2.13.0/hub-linux-amd64-2.13.0.tgz | tar xz -C /tmp && \
    mv /tmp/hub-linux-amd64-2.13.0/bin/hub /usr/local/bin
RUN curl -sL "https://github.com/smallstep/cli/releases/download/v0.14.0-rc.3/step_0.14.0-rc.3_linux_amd64.tar.gz" | tar -xz -C /tmp && mv /tmp/step*/bin/step /usr/local/bin
RUN ln -s /usr/bin/python3 /usr/local/bin/python3 && chmod +x /usr/local/bin/*
RUN /usr/local/bin/helm plugin install https://github.com/helm/helm-2to3
COPY select_kind /usr/local/bin/select_kind
COPY add_ns /usr/local/bin/add_ns
COPY separate_files /usr/local/bin/separate_files
COPY external_secret /usr/local/bin/external_secret
COPY tpctl.sh /root/tpctl
RUN cd /root/workdir
CMD [ "/root/tpctl"  ]
