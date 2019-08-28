#!/bin/bash
/usr/bin/sudo /usr/bin/salt-call --local --file-root=/home/${USER}/salt-wad/salt --pillar-root=/home/${USER}/salt-wad/pillar state.highstate
