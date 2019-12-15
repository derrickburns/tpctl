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
RUN curl -sL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get && \
    bash get_helm.sh && \
    rm get_helm.sh
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
RUN curl -sL https://github.com/github/hub/releases/download/v2.11.2/hub-linux-amd64-2.11.2.tgz | tar xz -C /tmp/ && \
    mv /tmp/hub-linux-amd64-2.11.2/bin/hub . && \
    chgrp root hub && \
    chown root hub && \
    mv hub /usr/local/bin
RUN curl -sL -o /usr/local/bin/fluxctl https://github.com/fluxcd/flux/releases/download/1.14.2/fluxctl_linux_amd64
RUN curl -sL -o /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    curl -sL -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    curl -sL -o /usr/local/bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
RUN mv ~/.local/bin/* /usr/local/bin
RUN curl -sL https://github.com/derailed/k9s/releases/download/0.8.4/k9s_0.8.4_Linux_x86_64.tar.gz | tar xz -C /tmp && \
    mv /tmp/k9s /usr/local/bin
RUN curl -sL -o /usr/local/bin/linkerd https://github.com/linkerd/linkerd2/releases/download/stable-2.6.0/linkerd2-cli-stable-2.6.0-linux 
#RUN curl -sL -o /usr/local/bin/glooctl https://github.com/solo-io/gloo/releases/download/v1.0.0/glooctl-linux-amd64
RUN curl -sL -o /usr/local/bin/glooctl https://nl.solo.io/events/public/v1/track/c/*W4D5DLs4ZV25kW68r9487zkQJy0/*W23_QMN6SH9sLVdMrlC8QT5CN0/5/f18dQhb0S1Wb2RwFJFTvY5j2pw_gyN68LkBljYw_YW85CsW11sZyf0W8Dc4Hq3qmP2VVWLWR34QGnhMW5DppFq1Fsy4wW73skM98Z1Yl4N4G48hMhHtyDN5dbngwbm-cZW6YCC-r7Vhs5YN4G0PZpYN828W8-00GX6wj-_bW5TYGcW6GLT7lN1x2HNdm2gM0W4VGjTp1QRgMMN8NHFyVjrlDFW607CkN2Q4kbHW8Y_DM17ZFHJjN1kp_kbrxqz9N4LlsBt9ZJdYW3KL0Zd3zYw12VzlwGz1XpqqDW9fbDKj1TRP3DW3rgcJb7qzz9NW3qBsD838ZmwfW4H_qH18jx__dVNBwPh8NzT9hW5vSDwF7v0zk-W2FjZNy5j-J31W5MyMT32M6tNnW57YlTm8yJSVzW41-Sx92PLrDjW2yS8ZW89K-R4W2z3Vxn7zZq7zW20xb503VQZn5W7Ch1s26gLjTLW3KqKsM6tTzY7W4_gLFG6g1m53W83dLG_84rSMgW26lPqD1yFV55W1HnBbb5yxBgRW1_S7-t2Xd29pW9gyk2x2HKP_fW66b5QT2rf5_7W7DThDn411Sp_W8J1_2Z70RxVnW5c3T0h1rJ8BfW6P_9Yj1V2Z07W91lQDD2Bw-SnW7v1QlG9fl2hVf5n2LtT04?_ud=0207b7ea-a1cd-44ae-81b8-656ddc66aa97
RUN curl -sL /usr/local/bin/hub https://github.com/github/hub/releases/download/v2.13.0/hub-linux-amd64-2.13.0.tgz | tar xz -C /tmp && \
    mv /tmp/hub-linux-amd64-2.13.0/bin/hub /usr/local/bin
RUN ln -s /usr/bin/python3 /usr/local/bin/python3 && chmod +x /usr/local/bin/*
COPY separate_files /usr/local/bin/separate_files
COPY external_secret /usr/local/bin/external_secret
COPY tpctl.sh /root/tpctl
RUN cd /root/workdir
CMD [ "/root/tpctl"  ]
