FROM mcr.microsoft.com/dotnet/nightly/sdk:9.0-noble-aot AS build

WORKDIR /app/src
COPY PushoverStub/PushoverStub.csproj .
RUN dotnet restore
COPY PushoverStub .
RUN dotnet publish -c Release -o /app/out/PushoverStub /p:DebugType=None /p:DebugSymbols=false
COPY --chmod=755 start.sh /app/out

WORKDIR /app/pb
COPY --chmod=755 postybirb-plus.AppImage .
RUN ./postybirb-plus.AppImage --appimage-extract \
    && mv squashfs-root /app/out/pb

FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    libglib2.0-0t64 \
    libnss3 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0t64 \
    libcups2t64 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2t64 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -mU postybirb
USER postybirb
WORKDIR /app

RUN mkdir -p /app/data /home/postybirb/.config \
    && ln -s /app/data/data /home/postybirb/PostyBirb \
    && ln -s /app/data/config /home/postybirb/.config/postybirb-plus
COPY --from=build --chown=postybirb:postybirb /app/out .

EXPOSE 9247 5000
VOLUME /app/data
ENTRYPOINT ["/app/start.sh"]
