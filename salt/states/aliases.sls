---
include:
  - states/users

{% for account in pillar['accounts'] %}

aliases_install_{{ account.user }}:
  file.managed:
    - name: /home/{{ account.user }}/.bash_aliases
    - source: salt://salt/files/aliases/bash_aliases
    - user: {{ account.user }}
    - group: {{ account.user }}
    - mode: 600
    - require:
      - sls: states/users

{% endfor %}
