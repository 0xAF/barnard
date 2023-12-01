#!/bin/bash
pulse_dev=$(pactl list short sources | grep -oP "alsa_input.*AIOC\S+")
barnard_fifo="./zz"

function detect_silence {
  #arecord -D pulse $pulse_dev -f S16_LE -c 1 -r 22050 -t raw | \

  parec -d $pulse_dev --raw --rate 22050 --latency=1 2>/dev/null | \
  sox -q --norm=-0 -t raw -r 22k -e signed -b 16 -c 1 -V1 - -t raw /dev/null \
    silence 1 0.1 1% 1 0.1 1%
}

function detect_audio {
  parec -d $pulse_dev --raw --rate 22050 --latency=1 2>/dev/null | \
  grep -Fqm 1 .
}

while [ 1 ]; do
  detect_audio
  echo "micup" > $barnard_fifo
  detect_silence
  echo "micdown" > $barnard_fifo
  sleep .1
done

