docker-repo:
  pkgrepo.managed:
    - humanname: Official Docker Repository
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable
    - key_url: https://download.docker.com/linux/ubuntu/gpg

apt-transport-https:
  pkg:
    - installed

ca-certificates:
  pkg:
    - installed

software-properties-common:
  pkg:
    - installed

docker-ce:
  pkg:
    - installed
