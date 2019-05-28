#!/bin/bash

unset ANSIBLE_CONFIG
unset EC2_INI_PATH

export BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export EC2_REGION="eu-west-2"
export ANSIBLE_INVENTORY="$BASEDIR/ec2_ini.py"
export ANSIBLE_ROLES_PATH="$BASEDIR/roles"
export ANSIBLE_SSH_ARGS="-C -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s"
export ANSIBLE_PRIVATE_KEY_FILE="$BASEDIR/../aws/automation"



