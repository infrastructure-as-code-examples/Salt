centos-release-gluster37:
  pkgrepo.managed:
    - baseurl: http://mirror.centos.org/centos/7/storage/x86_64/gluster-4.0/
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage

centos-release-storage-common:
  pkg:
    - installed

glusterfs-server:
  pkg:
    - installed

samba:
  pkg:
    - installed

glusterd:
  service.running:
    - enable: True
    - watch:
      - pkg: glusterfs-server
