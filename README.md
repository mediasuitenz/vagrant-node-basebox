vagrant-php-basebox
===================

Standardises development environment for node based projects

## Packaging a new version of the box

Perform the following commands:

- ```cd <repo-root>``` (where this file is located)
- ```git pull origin master``` to get any changes
- ```vagrant destroy```
- ```vagrant up```
- ```vagrant provision``` (may need to try this several times)
- ```rm vagrant-node-basebox.box```
- ```scripts/package```
- ```scripts/add_box_locally```

Once that has all completed you will have a new version of the node base box available
for use in vagrant projects.

## Using node-base-box

For vagrant projects that are using older versions of node-base-box, all you need
to do to update them is:

- ```cd <project-root>```
- ```vagrant destroy```
- ```vagrant up```
- ```vagrant provision```
