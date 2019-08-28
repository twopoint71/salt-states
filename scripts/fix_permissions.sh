#!/bin/bash

# directories
/usr/bin/find ~/salt-wad/ -type d -exec /bin/chmod 755 "{}" \;

# files
/usr/bin/find ~/salt-wad/ -type f -exec /bin/chmod 644 "{}" \;

# scripts
/usr/bin/find ~/salt-wad/scripts/ -type f -exec /bin/chmod 744 "{}" \;
