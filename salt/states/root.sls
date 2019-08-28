---
include:
  - states/vim


root_vimrc:
  file.managed:
    - name: /root/.vimrc
    - source: salt://files/vim/vimrc
    - user: root
    - group: root
    - mode: 644
    - require:
      - sls: states/vim

root_bashrc:
  file.managed:
    - name: /root/.bashrc
    - source: salt://files/root/bashrc
    - user: root
    - group: root
    - mode: 600

