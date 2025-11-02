FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update
RUN apt-get install -y lib32gcc-s1 unzip curl git git-lfs jq
RUN mkdir /app/Steam -p && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /app/Steam
RUN curl -sqL "https://github.com/dyc3/steamguard-cli/releases/download/v0.17.1/steamguard-cli_0.17.1-0.deb" > steamguard.deb
RUN apt-get install ./steamguard.deb
RUN curl -sqL "https://github.com/WilliamVenner/fastgmad/releases/download/v0.2.0/fastgmad_linux.zip" > fastgmad_linux.zip
RUN unzip fastgmad_linux.zip fastgmad
RUN /app/Steam/steamcmd.sh +quit
COPY "push.sh" /app
RUN chmod +x /app/push.sh

ENTRYPOINT "/app/push.sh"