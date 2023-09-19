#!/usr/bin/env bash
##############################################################################################
# Wait for a url to contain a substring in the title attribute
#
# Example: ./wait-endpoint -u "https://google.com" -t "google" -s 10 -o 300
##############################################################################################
# based on the work of: https://gist.github.com/eisenreich/195ab1f05715ec86e300f75d007d711c


wait_for_page() {
    echo "Testing: \"$1\" for \"$2\" in the title, with a timeout of $3s"

    r=$(curl -s -L "${1}" | grep \<title\> | xargs | sed s/"<title>"// | sed s/"<\/title>"//)
    echo "$r"

    timeout --foreground -s TERM "${3}s" bash -c \
        'while [[ "$(curl -s -L "${0}" | grep \<title\> | xargs | sed s/"<title>"// | sed s/"<\/title>"//)" != *"${1}"* ]];\
        do echo "Waiting ${0} for ${1} in the title" && sleep ${2};\
        done' "${1}" "${2}" "${4}"

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

# Read input parameters
while getopts u:t:s:o:   option
do
  case "${option}"
  in
    u) URL=${OPTARG};;
    t) TITLE=${OPTARG};;
    s) SLEEP=${OPTARG};;
    o) TIMEOUT=${OPTARG};;
    *) echo "usage: $0 -u <URL> -t <PAGE TITLE>" >&2
       exit 1 ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$URL" ]
then
    echo "URL empty, exiting"
    exit 1
fi

if [ -z "$TITLE" ]
then
    echo "page title empty, exiting"
    exit 1
fi

if [ -z "$SLEEP" ]
then
  SLEEP=15
fi

if [ -z "$TIMEOUT" ]
then
  TIMEOUT=300
fi

wait_for_page "${URL}" "${TITLE}" "${TIMEOUT}" "${SLEEP}"

echo ""
echo "SUCCESSFUL"