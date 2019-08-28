---
include:
  - states/users

tmux_install:
  pkg.installed:
    - pkgs:
      - tmux

{% for account in pillar['accounts'] %}

tmux_install_{{ account.user }}:
  file.managed:
    - name: /home/{{ account.user }}/.tmux.conf
    - source: salt://files/tmux/tmux.conf
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 644
    - require:
      - pkg: tmux_install
      - sls: states/users

{% endfor %}
