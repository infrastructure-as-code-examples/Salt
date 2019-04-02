git:
  pkg:
    - installed

mule-distribution:
  git.latest:
    - name: https://gitlab.com/iac-example/mule-ee-distribution.git
    - rev: master
    - target: /tmp/mule-ee-distribution
    - force_clone: True

mule-distribution-extract:
  archive.extracted:
    - name: /opt/
    - source: /tmp/mule-ee-distribution/mule-ee-distribution-standalone-4.1.1.zip
    - user: root
    - group: root
    - keep_source: True

/usr/lib/systemd/system/mule.service:
  file.managed:
    - source: salt://mule-package/mule.service
    - user: root
    - group: root
    - mode: 777

/etc/systemd/system/multi-user.target.wants/mule.service:
  file.symlink:
    - target: /usr/lib/systemd/system/mule.service
    - user: root
    - group: root
    - mode: 644

mule:
  service.running:
    - enable: True

java-1.8.0-openjdk.x86_64:
  pkg:
    - installed
