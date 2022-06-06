FROM        python:3.9.13-alpine3.16

RUN         apk add --no-cache gcc libc-dev

RUN         python3 -m pip install -U yt-dlp

WORKDIR     /download

ENTRYPOINT  [ "yt-dlp" ]