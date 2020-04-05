FROM node:12-buster

RUN apt-get update && apt-get install -y   \
    groff                               \
    jq                                  \
    less                                \
    python                              \
    python-pip                          \
    python-virtualenv                   \
    rsync                               \
    tree                                \
    zip                                 \
          &&                            \
    rm -rf /var/lib/apt/lists/*     &&  \
    apt-get clean                   &&  \
    npm install --global claudia        \
          &&                            \
    pip install --upgrade awscli


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

