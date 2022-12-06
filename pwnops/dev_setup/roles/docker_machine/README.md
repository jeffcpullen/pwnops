pwnops.dev_setup.docker_machine
=========

Role to install docker-machine on a mac.

Currently broken due to bug with docker-machine <https://github.com/machine-drivers/docker-machine-driver-xhyve/issues/229>

Requirements
------------

Brew installed

ansible-galaxy install -r requirements.yml

Role Variables
--------------

| variable name | default | description |
| ------------------------| -------- | ------------------------------------ |
| docker_machine_upgrade | unset | upgrade homebrew before installing (true,false) |
| docker_machine_latest | false | Use latest rather than present for docker-machine cask |
| docker_machine_vm_name | default | Name of the docker-machine instance |

Dependencies
------------

None

Example Playbook
----------------


    - hosts: localhost
      connection: local
      tasks:

        - name: Run docker_machine role
          ansible.builtin.include_role:
            name: docker_machine

License
-------

MIT

Author Information
------------------

Jeff Pullen
