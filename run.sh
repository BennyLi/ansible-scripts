#! /usr/bin/env bash

# ----- Variables {{{1

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
PYTHON_VIRTUAL_ENV_NAME=".virtualenv"

INVENTORY=""
PLAYBOOK="playbook.yml"
ANSIBLE_CMD="ansible-playbook --ask-become-pass"

# ----- Functions {{{1

source "${PROJECT_ROOT}/scripts/helper.sh"
source "${PROJECT_ROOT}/scripts/virtualenv.sh"
source "${PROJECT_ROOT}/scripts/requirements.sh"


print_usage() {
  echo "Usage:"
  echo "  $0 <name-of-device-from-inventory> [-t <tag-name>]..."
  echo ""
  echo "Known devices are [ $(ls --color=never -m ${PROJECT_ROOT}/machines) ]"
  echo "Known task tags are: [ $(ansible-playbook --list-tags $PLAYBOOK 2> /dev/null | grep "TASK TAGS" | cut --delimiter="[" --field 2 | cut --delimiter="]"  --field=1) ]"
}

# ----- MAIN {{{1

setup_virtualenv

display_msg "Installing ${BOLD}base requirements${RESET} (like ansible itself) in the virtual env"
pip install -r $PROJECT_ROOT/requirements_python.txt > /dev/null
install_python_requirements
install_ansible_requirements

ansible-playbook \
  --ask-become-pass \
  --inventory machines/dev_machine \
  --extra-vars user_name_from_env="$(id --user --name)" \
  --extra-vars user_group_from_env="$(id --group --name)" \
  --extra-vars user_shell_from_env="$(echo $SHELL | sed -En 's/.*\/(\w*)/\1/p')" \
  "$@" \
  playbook.yml
