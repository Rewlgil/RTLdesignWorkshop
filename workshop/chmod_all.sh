#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

for d in [ws][0-9]*; do
  [[ -d "$d" && "$d" =~ ^[ws][0-9]+$ ]] || continue
  files=("$d"/*.sh)
  ((${#files[@]})) || continue
  chmod +x "${files[@]}"
  echo "chmod +x ${d}/*.sh"
done
