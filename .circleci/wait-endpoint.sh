#!/usr/bin/env bash
##############################################################################################
# Wait for URLs until return HTTP 200
#
# - Just pass as many urls as required to the script - the script will wait for each, one by one
#
# Example: ./wait_for_urls.sh "${MY_VARIABLE}" "http://192.168.56.101:8080"
##############################################################################################
# Original author: https://gist.github.com/eisenreich/195ab1f05715ec86e300f75d007d711c
# modified with a timeout of 300s seconds and a retry of ever 10

TIMEOUT=3
SLEEP=1

wait-for-url() {
    echo "Testing: $1"
    # shellcheck disable=SC2016
    timeout --foreground -s TERM "${2}s" bash -c \
        'while [[ "$(curl -s -o /dev/null -m 3 -L -w ''%{http_code}'' ${0})" != "200" ]];\
        do echo "Waiting for ${0}" && sleep ${1};\
        done' "${1}" "${3}"

    local TIMEOUT_RETURN="$?"
    echo $TIMEOUT_RETURN
    if [[ "${TIMEOUT_RETURN}" == 0 ]]; then
        echo "OK: ${1}"
        return
    elif [[ "${TIMEOUT_RETURN}" == 124 ]]; then
        echo "TIMEOUT: ${1} -> EXIT"
        exit "${TIMEOUT_RETURN}"
    else
        echo "Other error with code ${TIMEOUT_RETURN}: ${1} -> EXIT"
        exit "${TIMEOUT_RETURN}"
    fi
}

echo "Wait for URLs: $*"

for URL in "$@"; do
    echo ""
    wait-for-url "${URL}" "${TIMEOUT}" "${SLEEP}"
done

echo ""
echo "SUCCESSFUL"