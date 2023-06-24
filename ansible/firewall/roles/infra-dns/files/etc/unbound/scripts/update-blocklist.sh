#!/bin/bash

: "${BLOCKLIST_FILE=/etc/unbound/conf.d/blocklist.conf}"
: "${HOST_BLOCKLIST=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts}"

echo -e "Downloading Blocklist Source"
curl --silent -o "$BLOCKLIST_FILE" -L "$HOST_BLOCKLIST"
echo -e "Host list downloaded ..."
sed -i -E -n 's/#.*//;s/[ ^I]*$//;/^$/d;/0.0.0.0 0.0.0.0$/d;/0.0.0.0/p' $BLOCKLIST_FILE
echo -e "Host list cleaned ..."

echo -e "Creating Unbound Blocklist"
LC_COLLATE=C sort -uf -o $BLOCKLIST_FILE{,}
sed -i -E -n 's/0.0.0.0 /local-zone: "/;/local-zone:/s/$/." always_null/p' $BLOCKLIST_FILE

sed -i '1s/^/server:\n/' $BLOCKLIST_FILE
echo -e "All lists sorted & uniquely merged to Unbound blocklist format ..."

if [[ -z "${NO_RELOAD}"]]; then
    set -x; unbound-control reload_keep_cache
fi
