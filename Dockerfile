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
        pyvmomi

# Install ansible
ENV ANSIBLE_VERSION=6.3.0
RUN pip3 install ansible==${ANSIBLE_VERSION}

# Install ansible collection for cisco datacenter
RUN ansible-galaxy collection install \
        cisco.aci:==2.2.0 \ 
        cisco.dcnm:==2.1.1 \
        cisco.intersight:==1.0.19 \
        cisco.ios:==3.3.0 \
        cisco.iosxr:==3.3.0 \
        cisco.mso:==2.0.0 \
        cisco.nso:==1.0.3 \
        cisco.nxos:==3.1.0 \
        cisco.ucs:==1.8.0 \
        community.general:==5.5.0

ENV TERRAFORM_VERSION=1.2.8
RUN curl -sSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip 2>&1 \
    && unzip -d /usr/bin /tmp/terraform.zip \
    && chmod +x /usr/bin/terraform \
    && mkdir -p /root/.terraform.cache/plugin-cache \
    && rm -f /tmp/terraform.zip \
    && terraform -install-autocomplete