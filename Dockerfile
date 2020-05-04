FROM tidepool/tpctl-base:latest AS tpctl-base

FROM ubuntu:18.04 AS tpctl
ENV TERM xterm-256color
ENV TZ America/Los_Angeles
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get --no-install-recommends install git openssh-client curl python3-setuptools python3-pip python3 locales -y && \
    pip3 install --no-cache-dir --upgrade --user awscli boto3 environs && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
COPY --from=tpctl-base \
     /usr/local/bin/jq \
     /usr/local/bin/helm \
     /usr/local/bin/eksctl \
     /usr/local/bin/kubectl \
     /usr/local/bin/kubecfg \
     /usr/local/bin/kubectx \
     /usr/local/bin/kubeval \
     /usr/local/bin/kubens \
     /usr/local/bin/yq \
     /usr/local/bin/aws-iam-authenticator \
     /usr/local/bin/fluxctl \
     /usr/local/bin/linkerd \
     /usr/local/bin/glooctl \
     /usr/local/bin/hub \
     /usr/local/bin/sops \
     /usr/local/bin/python3 \
     /usr/local/bin/
COPY cmd /usr/local/bin/
COPY pkgs /templates/pkgs/
COPY lib  /templates/lib/
COPY eksctl  /templates/eksctl/
ENV TEMPLATE_DIR /templates/
ENV COMMAND_DIR /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/tpctl.sh"  ]
