---
include:
  - states/users

gpg_install:
  pkg.installed:
    - pkgs:
      - gpg

{% for account in pillar['accounts'] %}

gpg_terminal_{{ account.user }}:
  file.append:
    - name: /home/{{ account.user }}/.bashrc
    - text: export GPG_TTY=$(tty)

{% endfor %}
