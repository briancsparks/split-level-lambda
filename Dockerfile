FROM node:12-stretch-slim

WORKDIR /tmp/zz_packages

RUN apt-get update && apt-get install -y --no-install-recommends   \
    curl                                \
    ca-certificates                     \
    groff                               \
    jq                                  \
    less                                \
    rsync                               \
    tree                                \
    zip                                 \
    unzip                               \
          &&                            \
    rm -rf /var/lib/apt/lists/*     &&  \
    apt-get clean                   &&  \
    npm install --global claudia        \
          &&                            \
    mkdir -p aws &&                     \
    cd aws &&                           \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  && \
    unzip awscliv2.zip              &&  \
    ./aws/install                   &&  \
    cd ..                           &&  \
    rm -rf aws


WORKDIR /work/sll/bin

COPY bin/* ./

RUN chmod +x *

# sll === split-level-lambda
WORKDIR /work/sll/app

COPY package.json package-lock*.json yarn* ./

RUN ../bin/npm-install-or-yarn

COPY . .

WORKDIR /work/nodejs

#ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["node", "index.js"]

ENTRYPOINT ["/work/sll/bin/entrypoint"]

