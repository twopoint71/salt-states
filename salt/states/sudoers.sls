---
include:
  - states/users

sudoers:
  file.managed:
    - name: /etc/sudoers.d/nopass_allow
    - source: salt://salt/files/sudoers/nopass_allow
    - user: root
    - group: root
    - mode: 644

{% set sudoers = { "Debian": "sudo", "RedHat": "sudoers" } %}

{% for account in pillar['accounts'] %}
{% if account.sudoers %}

sudoers_{{ account.user }}:
  user.present:
    - name: {{ account.user }}
    - groups:
      - {{ sudoers[grains.os_family] }}
    - require:
      - sls: states/users

{% endif %}
{% endfor %}
