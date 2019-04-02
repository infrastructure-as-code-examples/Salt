postgresql:
  pkgrepo.managed:
    - humanname: PostgreSQL 10 Repository
    - baseurl: https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7.5-x86_64/
    - gpgkey: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG

postgresql10-server:
  pkg:
    - installed

postgresql-first-run-init:
  cmd.run:
    - name: /usr/pgsql-10/bin/postgresql-10-setup initdb
    - unless: stat /var/lib/pgsql/10/data/postgresql.conf
    - runas: root

postgresql-10:
  service.running:
    - enable: True
    - watch:
      -  pkg: postgresql10-server
