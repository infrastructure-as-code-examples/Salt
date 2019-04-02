docker-repo:
  pkgrepo.managed:
    - humanname: Official Docker Repository
    - baseurl: https://download.docker.com/linux/centos/7/x86_64/stable/
    - gpgkey: https://download.docker.com/linux/centos/gpg

yum-utils:
  pkg:
    - installed

device-mapper-persistent-data:
  pkg:
    - installed

lvm2:
  pkg:
    - installed

docker-ce:
  pkg:
    - installed

docker:
  service.running:
    - enable: True
    - watch:
      - pkg: docker-ce
