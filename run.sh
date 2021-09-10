#! /usr/bin/env bash

# See https://kvz.io/bash-best-practices.html for some best practices I use
set -o errexit
set -o pipefail
set -o nounset

# Only when debugging
#set -o xtrace



# ----- Variables {{{1

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
PYTHON_VIRTUAL_ENV_NAME=".virtualenv"

INVENTORY=""
PLAYBOOK="playbook.yml"
ANSIBLE_ARGS=""

VAULT_PASSWORD_FILE="./.vault_pass"

# ----- Functions {{{1

source "${PROJECT_ROOT}/scripts/helper.sh"
source "${PROJECT_ROOT}/scripts/virtualenv.sh"
source "${PROJECT_ROOT}/scripts/requirements.sh"


function print_usage() {
  cat <<USAGE
Usage:
  $0 -m <name-of-device-from-inventory> [-t <tag-name>]...

Known devices are [ $(ls --color=never -m ${PROJECT_ROOT}/machines) ]
Known task tags are: [ $(ansible-playbook --list-tags $PLAYBOOK 2> /dev/null | grep "TASK TAGS" | cut --delimiter="[" --field 2 | cut --delimiter="]"  --field=1) ]

Arguments:
  -h   --help        Show this help message.
  -i   --inventory
  -m   --machine     Add this machine to the list of machine that should be provisioned.

All command line arguments accepted by the ansible-playbook command can be provided. They will be passed through.
USAGE
}

function handle_arguments() {
  if [ $# -le 1 ]
  then
    display_error "You must atleast provide a machine to provision!"
    print_usage
    exit 1
  fi

  while [ $# -gt 0 ]
  do
    case "$1" in
      -h|--help)
        print_usage
        exit 0
        ;;
      -i|-m|--inventory|--machine)
        shift
        [ ! -z "$INVENTORY" ] && INVENTORY="${INVENTORY},"
        INVENTORY="${INVENTORY}${1}"
        shift
        ;;
      *)
        ANSIBLE_ARGS="${ANSIBLE_ARGS} ${1}"
        shift
        ;;
    esac
  done
}

function add_vault_pass_file_arg() {
  if [ -f "$VAULT_PASSWORD_FILE" ]
  then
    ANSIBLE_ARGS="${ANSIBLE_ARGS} --vault-password-file ${VAULT_PASSWORD_FILE}"
  else
    echo "Password file not found!"
    exit 3
  fi
}

# ----- MAIN {{{1

handle_arguments "$@"
add_vault_pass_file_arg
display_msg "I will provision these machines: ${INVENTORY}"
display_msg "Passing '${ANSIBLE_ARGS}' as arguments to the ansible-playbook command"

setup_virtualenv

display_msg "Installing ${BOLD}base requirements${RESET} (like ansible itself) in the virtual env"
#pip install -r $PROJECT_ROOT/requirements_python.txt > /dev/null
#install_python_requirements
#install_ansible_requirements

ansible-playbook \
  --ask-become-pass \
  --inventory "${INVENTORY}" \
  --extra-vars user_name_from_env="$(id --user --name)" \
  --extra-vars user_group_from_env="$(id --group --name)" \
  --extra-vars user_shell_from_env="$(echo $SHELL | sed -En 's/.*\/(\w*)/\1/p')" \
  ${ANSIBLE_ARGS} \
  playbook.yml
