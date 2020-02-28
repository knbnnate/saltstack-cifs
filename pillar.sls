#!jinja|yaml|gpg

cifs:
  mounts:
    - name: mountname
      path: /mnt/mountmehere
      username: azureexamplestorageaccount
      password: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        encrypted hunter6 here
        -----END PGP MESSAGE-----
      unc: //azureexamplestorageaccount.file.core.windows.net/azureexampleshare
      options:
        - nofail
        - vers=2.1
        - dir_mode=0777
        - file_mode=0777
        - serverino
