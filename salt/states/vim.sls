---
include:
  - states/users

vim_install:
  pkg.installed:
    - pkgs:
      - vim

{% for account in pillar['accounts'] %}

vimrc_install_{{ account.user }}:
  file.managed:
    - name: /home/{{ account.user }}/.vimrc
    - source: salt://salt/files/vim/vimrc
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 644
    - require:
      - pkg: vim_install
      - sls: states/users

{% endfor %}
