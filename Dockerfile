FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
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
WORKDIR /home/postybirb

RUN mkdir -p /home/postybirb/data /home/postybirb/.config \
    && ln -s /home/postybirb/data/data /home/postybirb/PostyBirb \
    && ln -s /home/postybirb/data/config /home/postybirb/.config/postybirb-plus
COPY --chown=postybirb:postybirb --chmod=755 start.sh postybirb-plus.AppImage ./
RUN ./postybirb-plus.AppImage --appimage-extract \
    && mv squashfs-root app \
    && rm postybirb-plus.AppImage

EXPOSE 9247
VOLUME /home/postybirb/data
ENTRYPOINT ["/home/postybirb/start.sh"]
