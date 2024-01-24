#!/usr/bin/env bash

#source_dirs="lib bin"
source_dirs="bin/main.ml"
args=${*:-"bin/main.exe"}
cmd="dune exec ${args}"

function sigint_handler() {
  kill -9 "$(jobs -p)"
  trap - SIGINT
  exit 0
}

trap sigint_handler SIGINT

while true; do
  dune build
  $cmd &
  fswatch -1 -v $source_dirs
  #fswatch -r -1 $source_dirs
  printf "\nRestarting server.exe due to filesystem change\n"
  kill -9 "$(jobs -p)"
done

trap - SIGINT
