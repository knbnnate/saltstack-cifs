cifs.client:
  pkg.installed:
    - pkgs:
      - cifs-utils

{%- for mount in salt['pillar.get']('cifs:mounts', []) %}
{%- set mount_name = mount.get('name','mount{0}'.format(loop.index)) %}
cifs.{{ mount_name }}.mountpoint:
  file.directory:
    - name: {{ mount.get('path','/mnt/{0}'.format(mount_name)) }}
{%- if mount.get('password',False) %}
cifs.{{ mount_name }}.credentials_file:
  file.managed:
    - name: /etc/smbcredentials/{{ mount_name }}.cred
    - mode: '0600'
    - makedirs: True
cifs.{{ mount_name }}.credentials:
  file.append:
    - name: /etc/smbcredentials/{{ mount_name }}.cred
    - text:
      - username={{ mount.get('username','') }}
      - password={{ mount.get('password','') }}
{%- set credentials_option = ',credentials=/etc/smbcredentials/{0}.cred'.format(mount_name) %}
{%- else %}
{%- set credentials_option = '' %}
{%- endif %}
{%- if mount.get('options',[])|length > 0 %}
{%- set mount_options=mount.get('options',[])|join(',') %}
{%- else %}
{%- set mount_options='defaults' %}
{%- endif %}
cifs.{{ mount_name }}.fstab:
  file.append:
    - name: /etc/fstab
    - text:
      - {{ mount.get('unc','') }} {{ mount.get('path','/mnt/{0}'.format(mount_name)) }} cifs {{ mount_options }}{{ credentials_option }}
cifs.{{ mount_name }}.mounted:
  mount.mounted:
    - name: {{ mount.get('path','/mnt/{0}'.format(mount_name)) }}
    - device: {{ mount.get('unc','') }}
    - fstype: cifs
    - opts: {{ mount_options }}{{ credentials_option }}
{%- endfor %}
