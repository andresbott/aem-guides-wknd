#!/bin/bash

# crate-user-osgi-cfg.sh
# ------------------
# This script will generate an osgi config that uses repo init to add and remove an user
#
#

function printHelp(){
cat << EOF
Usage: create-user-osgi-cfg.sh [-u username] [-p password] -q [true]
the username and the password will be printed out at the end

-u [username]: set the username, if left empty it will be randomized with pattern: testadmin-NUMBER.
-p [password]: set the password, if left empty it will be randomized.
-q [true]: quiet, don't print the user/password

EOF
}
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  printHelp
  exit
fi

# Read input parameters
while getopts u:p:q: option
do
  case "${option}"
  in
    u) NAME=${OPTARG};;
    p) PASS=${OPTARG};;
    q) QUIET=${OPTARG};;
  esac
done
shift $((OPTIND -1))

## generate a random password
if [ -z "$PASS" ]
then
    PASS=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 30)
fi
## create a random user if no name was provided
if [ -z "$NAME" ]
then
    number=$RANDOM
    NAME="testadmin-$number"
fi

# shellcheck disable=SC2089
JSON_ADD='{
"scripts":"delete user '"${NAME}"'\ncreate user '"${NAME}"' with password '"${PASS}"'\nadd '"${NAME}"' to group administrators"
}'
echo "${JSON_ADD}" > "org.apache.sling.jcr.repoinit.RepositoryInitializer~testadmin-user-add.cfg.json"

JSON_RM='{
"scripts":"delete user '"${NAME}"'"
}'
echo "${JSON_RM}" > "org.apache.sling.jcr.repoinit.RepositoryInitializer~testadmin-user-remove.cfg.json"

# print the output
if [  -z "$QUIET" ]
then
echo "$NAME $PASS"
fi






