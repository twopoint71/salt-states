---
include:
  - states/users

ssh_install:
  pkg.installed:
    - pkgs:
      - openssh-client

{% for account in pillar['accounts'] %}

ssh_dir_{{ account.user }}:
  file.directory:
    - name: /home/{{ account.user }}/.ssh
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 700
    - require:
      - sls: states/users

ssh_config_{{ account.user }}:
  file.managed:
    - name: /home/{{ account.user }}/.ssh/config
    - source: salt://files/ssh/config
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 600
    - unless: if [ -e /home/{{ account.user }}/.ssh/config ]; then exit 0; else exit 1; fi
    - require:
      - file: ssh_dir_{{ account.user }}

ssh_authorized_keys_{{ account.user }}:
  file.managed:
    - name: /home/{{ account.user }}/.ssh/authorized_keys
    - source: salt://files/ssh/authorized_keys
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 600
    - unless: if [ -e /home/{{ account.user }}/.ssh/authorized_keys ]; then exit 0; else exit 1; fi
    - require:
      - file: ssh_dir_{{ account.user }}

ssh_keygen_{{ account.user }}:
  cmd.run:
    - name: /usr/bin/sudo --user={{ account.user }} /usr/bin/ssh-keygen -b 4096 -t rsa -C "{{ account.user }}@$(hostname)" -N "" -f "/home/{{ account.user }}/.ssh/id_rsa_salt_generated"
    - unless: if [ -e /home/{{ account.user }}/.ssh/id_rsa_salt_generated ]; then exit 0; else exit 1; fi
    - require:
      - file: ssh_dir_{{ account.user }}

{% endfor %}
