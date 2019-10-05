---
include:
  - states/users

nginx_pkgs:
  pkg.installed:
    - pkgs:
      - nginx
      - nginx-common
      - nginx-doc

{% set nginx_groups = { "Debian": "www-data", "RedHat": "nginx" } %}

{% for account in pillar['accounts'] %}
{% for domain in account.domains %}
{% set nginx_conf = "/etc/nginx/sites-available/{}.conf".format(domain) %}

nginx_domain_dir_{{ account.user }}_{{ domain }}:
  file.directory:
    - name: /home/{{ account.user }}/{{ domain }}
    - user: {{ account.user }}
    - group: {{ nginx_groups[grains.os_family] }}
    - mode: 755

nginx_htdocs_dir_{{ account.user }}_{{ domain }}:
  file.directory:
    - name: /home/{{ account.user }}/{{ domain }}/htdocs
    - user: {{ account.user }}
    - group: {{ nginx_groups[grains.os_family] }}
    - mode: 755

nginx_sample_index_html_{{ account.user }}_{{ domain }}:
  file.managed:
    - name: /home/{{ account.user }}/{{ domain }}/htdocs/index.html
    - source: salt://files/nginx/index.html
    - user: {{ account.user }}
    - group: {{ nginx_groups[grains.os_family] }}
    - mode: 644
    - replace: false

nginx_domain_log_dir_{{ account.user }}_{{ domain }}:
  file.directory:
    - name: /var/log/nginx/{{ account.user }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

nginx_cache_dir_{{ account.user }}_{{ domain }}:
  file.directory:
    - name: /dev/shm/cache/{{ account.user }}/{{ domain }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

nginx_config_install_{{ account.user }}_{{ domain }}:
  file.managed:
    - name: {{ nginx_conf }}
    - source: salt://files/nginx/default.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: nginx_domain_dir_{{ account.user }}_{{ domain }}
      - file: nginx_domain_log_dir_{{ account.user }}_{{ domain }}
    - replace: false

nginx_config_setup_{{ account.user }}_{{ domain }}_domain:
  file.replace:
    - name: {{ nginx_conf }}
    - pattern: _DOMAIN_
    - repl: {{ domain }}
    - require:
      - file: nginx_config_install_{{ account.user }}_{{ domain }}
      - file: nginx_cache_dir_{{ account.user }}_{{ domain }}

nginx_config_setup_{{ account.user }}_{{ domain }}_account:
  file.replace:
    - name: {{ nginx_conf }}
    - pattern: _ACCOUNT_
    - repl: {{ account.user }}
    - require:
      - file: nginx_config_install_{{ account.user }}_{{ domain }}
      - file: nginx_cache_dir_{{ account.user }}_{{ domain }}

nginx_config_symlink_{{ account.user }}_{{ domain }}:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ domain }}.conf
    - target: /etc/nginx/sites-available/{{ domain }}.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: nginx_config_setup_{{ account.user }}_{{ domain }}_account
      - file: nginx_config_setup_{{ account.user }}_{{ domain }}_domain

{% endfor %} # end domains loop
{% endfor %} # end accounts loop

nginx_config_install_master:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx_pkgs

nginx_reload:
  service.running:
    - name: nginx
    - enable: true
    - reload: true
    - watch:
      - file: /etc/nginx/sites-enabled/*
      - file: /etc/nginx/sites-available/*
    - require:
      - pkg: nginx_pkgs
