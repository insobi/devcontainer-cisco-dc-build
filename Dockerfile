FROM ubuntu:20.04

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        build-essential \
        libssl-dev \
        libffi-dev \
        python-dev \
        python3-pip \
        git \
        wget \
        curl \
        tree \
        gawk \
        jq \
        iputils-ping \
        unzip \
        ssh \
        sshpass

# Install python packages for ansible
RUN pip3 install \
        paramiko \
        jmespath \
        pyvmomi \
        requests

# Install ansible
RUN pip3 install ansible

# Install ansible collection for cisco datacenter
RUN ansible-galaxy collection install \
        cisco.aci:==v2.5.0 \ 
        cisco.dcnm:==3.1.1 \
        cisco.intersight:==1.0.24 \
        cisco.ios:==4.4.0  \
        cisco.iosxr:==4.1.0 \
        cisco.mso:==2.2.1 \
        cisco.nso:==1.0.3 \
        cisco.nxos:==4.1.0 \
        cisco.ucs:==1.8.0 \
        community.general \
        community.vmware

ENV TERRAFORM_VERSION=1.4.4
RUN curl -sSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip 2>&1 \
    && unzip -d /usr/bin /tmp/terraform.zip \
    && chmod +x /usr/bin/terraform \
    && mkdir -p /root/.terraform.cache/plugin-cache \
    && rm -f /tmp/terraform.zip \
    && terraform -install-autocomplete

# To avoid error - "SSL: DH_KEY_TOO_SMALL] dh key too small" 
RUN mv /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.bak
COPY openssl.cnf /etc/ssl/openssl.cnf