FROM tidepool/tpctl-base:latest
ENV TERM xterm-256color
ENV TZ America/Los_Angeles
ENV DEBIAN_FRONTEND noninteractive
COPY cmd /usr/local/bin/
COPY pkgs /templates/pkgs/
COPY lib  /templates/lib/
COPY eksctl  /templates/eksctl/
ENV TEMPLATE_DIR /templates/
ENV COMMAND_DIR /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/tpctl.sh"  ]
