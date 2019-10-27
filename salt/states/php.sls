---
php_pkgs:
  pkg.installed:
    - pkgs:
      - php7.3
      - php7.3-cli
      - php7.3-common
      - php7.3-curl
      - php7.3-fpm
      - php7.3-mbstring

php_fpm_start:
  service.running:
    - name: php7.3-fpm
    - enable: true
    - reload: true
