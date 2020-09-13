#!/bin/bash

if [ -z ${1} ]
  then
    STATES=$(/bin/ls -F1 /home/${USER}/salt-wad/salt/states | awk '{gsub(/.sls/, "", $0); printf("    %s\n", $0)}')
    FIRST_STATE=$(/bin/ls -F1 /home/${USER}/salt-wad/salt/states | awk 'END {gsub(/.sls/, "", $0); printf("%s", $0)}')
cat <<HELP
Please supply a state name
Valid state names are:
${STATES}
Example:
    ${0} ${FIRST_STATE}
HELP
    exit 1
  fi

/usr/bin/sudo /usr/bin/salt-call --local --file-root=/home/${USER}/salt-wad --pillar-root=/home/${USER}/salt-wad/pillar state.sls salt/states/${1}
