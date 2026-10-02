#!/usr/bin/env bash
# Visit and reload a URL, logging status; exit non-zero on any failure.
# Usage: ping.sh [url] [rounds] [gap_seconds]
URL="${1:-https://mondera.in}"; ROUNDS="${2:-1}"; GAP="${3:-0}"
fail=0
for ((i=1; i<=ROUNDS; i++)); do
  for visit in load reload; do
    out=$(curl -sS -L -o /dev/null -m 60 -w "%{http_code} %{time_total}s" "$URL" 2>&1); code=${out%% *}
    echo "$(date -u +%FT%TZ) round=$i $visit $URL -> $out"
    [ "$code" = "200" ] || { echo "::error::$visit failed for $URL: $out"; fail=1; }
  done
  [ "$i" -lt "$ROUNDS" ] && sleep "$GAP"
done
exit $fail
