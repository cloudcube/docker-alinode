FROM ubuntu 

USER root


# Install required software
RUN \
    apt-get update && \
    apt-get install wget curl git python tree gcc g++ make openssl libssl-dev -y && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /root
ENV ALINODE_VERSION 1.3.0
ENV TNVM_DIR /root/.tnvm
RUN mkdir /tmp/node_log

RUN ln -snf /bin/bash /bin/sh

WORKDIR /root

# Install alinode v1.3.0 (node 4.2.6)
RUN wget -qO- https://raw.githubusercontent.com/aliyun-node/tnvm/master/install.sh | bash 
RUN echo $HOME
RUN source $HOME/.bashrc && \
        tnvm install "alinode-v$ALINODE_VERSION" && \
        tnvm use "alinode-v$ALINODE_VERSION" 
RUN source $HOME/.bashrc && npm install -g agentx
RUN git clone https://github.com/aliyun-node/commands.git /usr/local/src/alinode_commands

RUN npm install -g pm2

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
