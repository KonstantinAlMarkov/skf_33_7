FROM node:12

# Set working directory. Paths will be relative this WORKDIR.
WORKDIR /usr/src/app
VOLUME /usr/src/app

#Определяем регион
RUN truncate -s0 /tmp/preseed.cfg && \
    (echo "tzdata tzdata/Areas select Europe" >> /tmp/preseed.cfg) && \
    (echo "tzdata tzdata/Zones/Europe select Moscow" >> /tmp/preseed.cfg) && \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    apt-get install -y tzdata
#ставим основу - nodejs и npm
RUN apt-get update && apt-get install -y \
nano \
curl \
tzdata

# Install dependencies
COPY package*.json ./
RUN npm install

EXPOSE 3000 8080

#Удаляем файл для установки региона
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

