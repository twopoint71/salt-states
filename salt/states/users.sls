---
{% for account in pillar['accounts'] %}

user_present_{{ account.user }}:
  user.present:
    - name: {{ account.user }}
    - home: /home/{{ account.user }}

{% endfor %}
