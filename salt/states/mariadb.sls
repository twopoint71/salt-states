---
include:
  - salt/states/php

mariadb_pkgs:
  pkg.installed:
    - pkgs:
      - mycli
      - mariadb-client
      - mariadb-server


{% set default_password = pillar['mariadb']['default_password'] %}
{% if default_password == "_SET_PASSWORD_" %}
{%  set default_password = salt['cmd.run']('php -r "echo base64_encode(random_bytes(48));"') %}
{% endif %}

mariadb_pillar_file_create_default_password:
  file.line:
    - name: salt://pillar/mariadb.sls
    - content: "default_password: {{ default_password }}"
    - match: "default_password: _SET_PASSWORD_"
    - mode: replace

mariadb_service:
  service.running:
    - name: mysql
    - enable: true
    - reload: true
    - require:
      - pkg: mariadb_pkgs

mariadb_secure_root_pass_set:
  file.line:
    - name: salt://salt/files/mariadb/mariadb_secure_install.php
    - content: "$dbpass = \"{{ default_password }}\";"
    - match: "dbpass = *"
    - mode: replace
    - require:
      - file: mariadb_pillar_file_update_default_password
    - watch:
      - file: mariadb_secure_script_copy

mariadb_run_secure:
  cmd.run:
    - name: salt://salt/files/mariadb/mariadb_secure_install.php
    - cwd: salt://salt/files/mariadb/
    - require:
      - file: mariadb_secure_root_pass_set
