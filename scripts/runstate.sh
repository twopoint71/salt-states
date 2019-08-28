#!/bin/bash

if [ -z ${1} ]
  then
    echo "Please supply a state name"
    exit 1
  fi

/usr/bin/sudo /usr/bin/salt-call --local --file-root=/home/${USER}/salt-wad/salt --pillar-root=/home/${USER}/salt-wad/pillar state.sls states/${1}
