# salt-states

### Description
A small project to make sysadmin tasks less menacing and more predictable using saltstack. These states have been running around my systems in the wild for some years now, so it seems prudent to rein them into a tidy project. Should be generally compatible with most popular *nix distributions.

### Testing
These states have been tested the following ways:
* In a VirtualBox VM running RHEL 7
* On Windows Subsystem for Linux
* On Amazon's EC2 running Amazon Linux I

### Current states
* basic - os updates
* aliases - help not shoot yourself in the foot
* basic_pkgs - a few helpful things to have around
* gpg - adds gpg and terminal redirection (important for WSL)
* sudoers - manage the sudoers list dictated by pillar accounts.sls
* nginx - setup web services based on configuration in accounts.sls (still kind of a work in progress)
* network - tools for troubleshooting
* root - bashrc and vim configs
* ssh - initialize ssh for accounts, don't override anything (not listed in top.sls, run separately)
* tmux - setup with my preferred configuration
* users - manage the users via pillar accounts.sls
* vim - setup with my preferred configuration

### Todo
(things which exist, but are un-refined for this project yet)
* csf - installation, configuration, and daemonizing
* email - this one is too big, need to break out spam assassin, dovecot, account management, and postfix
* lets_encrypt - configure and install certificates based on accounts.sls configuration
* mariadb - installation, initial configuration, and daemonizing
* ntpd - setup time management
* php - installation and daemonizing(php-fpm)
* dev_tools - install and configure git, gcc, make, etc.

### How to use
```bash
$ git clone https://github.com/twopoint71/salt-states
$ cd salt-states
$ ./scripts/salt_install.sh
$ ./scripts/highstate.sh
```

### Scripts description
```
scripts/
├ fix_permissions.sh  - only really useful on Windows if running in WSL
├ highstate.sh        - execute all states listed in the top file (all but ssh)
├ runstate.sh         - execute only one state
└ salt_install.sh     - get salt installed so this stuff works
