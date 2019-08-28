#!/bin/bash

APT=/usr/bin/apt
SUDO=/usr/bin/sudo

${SUDO} ${APT} update

${SUDO} ${APT} install -y salt-minion
