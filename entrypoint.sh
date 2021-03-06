#!/bin/bash

function fail {
	echo "ERROR: $1" >&2
	exit 1
}

[[ -z "$CONF_RPCPASSWORD" ]] && fail "Required environment variable CONF_RPCPASSWORD not set."

if [[ -n "$NO_CHOWN" ]] ; then
	chown -R bitcoin:bitcoin /bitcoin/data || fail "Cannot change ownership of '/bitcoin/data'."
fi

env | grep '^CONF_\w\+=' | cut -d= -f1 | while read EVAR ; do
	CVAR=`echo "$EVAR" | cut -d_ -f2- | tr '[:upper:]' '[:lower:]'`
	echo -n "${!EVAR}" | xargs -d '|' -I '{}' echo "${CVAR}={}" >> /etc/bitcoin.conf
done

exec gosu "$@"
