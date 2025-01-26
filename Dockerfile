FROM debian:12.9-slim

ENV SERVER_NAME="Votre Serveur"

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y lib32gcc-s1 \
  sqlite3 \
  wget

ADD novalife-server /usr/local/bin/
RUN chmod +x /usr/local/bin/novalife-server

RUN useradd -m steamuser
USER steamuser
WORKDIR /home/steamuser

RUN mkdir steam_ds
WORKDIR /home/steamuser/steam_ds

RUN wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN ./steamcmd.sh +quit

RUN ./steamcmd.sh +login anonymous +force_install_dir /home/steamuser/novalife +app_update 1665030 validate +quit

WORKDIR /home/steamuser/novalife/
RUN mkdir -p /home/steamuser/.steam/sdk64
RUN ln -s /home/steamuser/novalife/linux64/steamclient.so /home/steamuser/.steam/sdk64/steamclient.so

EXPOSE 7777
CMD ["novalife-server"]
