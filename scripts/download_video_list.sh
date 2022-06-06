#! /bin/bash

YOUTUBE_DL_IMAGE="mikenye/youtube-dl"

AUDIO_YOUTUBE_DL_ARGS="-f bestaudio[ext=m4a]"
VIDEO_YOUTUBE_DL_ARGS=""


# $1 - the youtube video to download
# $2 - the upload directory to map to
# $3 - the mode which is used ('audio' | 'video')
spawn_downloader() {
   [ "$3" = 'audio' ] && args="${AUDIO_YOUTUBE_DL_ARGS}" || args="${VIDEO_YOUTUBE_DL_ARGS}"

    docker run                \
        --rm                  \
        -d                    \
        -e PGID="$(id -g)"    \
        -e PUID="$(id -u)"    \
        -v "$2":/workdir:rw    \
        "$YOUTUBE_DL_IMAGE" ${args[@]} "$1"
}

if ! command -v docker > /dev/null; then
    echo 'docker is required to run this script'
    exit 1
fi

if [ $# -lt 2 ]; then
    echo 'Usage: ./download_video_list.sh <list.txt> <path_to_download_directory>'
    exit 2
fi

[ $# -eq 3 ] && mode="$3" || mode='video'

if [ "$mode" != 'video' ] && [ "$mode" != 'audio' ]; then
    echo "Invalid mode: Mode can be video or audio"
    exit 3
fi

docker pull "${YOUTUBE_DL_IMAGE}"

while read -r youtube_video_url;
do
    spawn_downloader "${youtube_video_url}" "${2}" "$mode"
done < "$1"