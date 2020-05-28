FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# install prerequisities and set locale
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y openssl curl unzip locales awscli groff jq git && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# install terraform
RUN cd /tmp && \
    curl -q "https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip" -o tf.zip && \
    unzip -d . tf.zip && mv ./terraform /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform && \
    rm ./tf.zip

# install kubectl
RUN cd /tmp && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.10/bin/linux/amd64/kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# install helm
RUN cd /tmp && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install doctl
RUN cd /tmp && \
  curl -LO "https://github.com/digitalocean/doctl/releases/download/v1.33.1/doctl-1.33.1-linux-amd64.tar.gz" && \
  tar -zxvf doctl-1.33.1-linux-amd64.tar.gz && mv ./doctl /usr/local/bin/doctl && chmod +x /usr/local/bin/doctl

# configuration
ENV HOME=/tmp/home

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]