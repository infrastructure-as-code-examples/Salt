base:
  'roles:docker':
    - match: grain
    - docker-package
    - gluster-client

  'roles:gluster':
    - match: grain
    - gluster-package

  'roles:bind':
    - match: grain
    - bind-package

  'roles:postgres':
    - match: grain
    - postgres-package

  'roles:mule':
    - match: grain
    - mule-package
