#!/bin/bash

# Config
ROOT_HINTS=/etc/unbound/root.hints
ROOT_KEY=/etc/unbound/keys.d/root.key

# Script
## Download Root Servers List (root.hints) & Update Root Dnskey (root.key)
echo -e "Download Root Servers & Update Root Dnskey"
curl --silent -o "$ROOT_HINTS" -L "https://www.internic.net/domain/named.root"
chown unbound:unbound $ROOT_HINTS
chown unbound:unbound /etc/unbound/keys.d
runuser -u unbound -- unbound-anchor -a /etc/unbound/keys.d/root.key
echo -e "root.hints Downloaded & root.key Updated ..."

## Reload config without restart
if [[ -z "${NO_RELOAD}"]]; then
    echo -e "Reloading Unbound Config"
    set -x; unbound-control reload_keep_cache
fi

