FROM ubuntu:18.04

# install prerequisities and set locale
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y openssl curl unzip locales awscli groff jq && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# install terraform
RUN cd /tmp && \
    curl -q "https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_linux_amd64.zip" -o tf.zip && \
    unzip -d . tf.zip && mv ./terraform /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform && \
    rm ./tf.zip

# install kubectl
RUN cd /tmp && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# install helm
RUN cd /tmp && curl -LO https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz && \
    tar -zxvf helm-v2.14.3-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && rm -rf helm-v2.14.3-linux-amd64.tar.gz linux-amd64

# configuration
ENV HOME=/tmp/home

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]