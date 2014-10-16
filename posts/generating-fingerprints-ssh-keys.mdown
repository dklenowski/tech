Categories: linux
Tags: ssh
      fingerprint

- Generating fingerprints for all your ssh keys

        for i in ~/.ssh/*.pub; do ssh-keygen -l -f "$i"; done