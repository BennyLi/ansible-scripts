#! /usr/bin/env bash

function get_all_python_requirement_files() {
  find "$PROJECT_ROOT/roles" -name 'requirements_python.txt'
}

function get_all_ansible_requirement_files() {
  find "$PROJECT_ROOT/roles" -name 'requirements_ansible.yml'
}

function install_requirements() {
  install_python_requirements
  install_ansible_requirements
}

function install_python_requirements() {
  for requirement_file in $(get_all_python_requirement_files)
  do
    local role="$(echo "$requirement_file" | sed -nr 's|.*/?roles/(.*)/.*|\1|p')"
    display_msg "Installing python requirements for role ${BOLD}$role${RESET}"
    pip install -r "$requirement_file" > /dev/null
  done
}

function install_ansible_requirements() {
  for requirement_file in $(get_all_ansible_requirement_files)
  do
    local role="$(echo "$requirement_file" | sed -nr 's|.*/?roles/(.*)/.*|\1|p')"
    display_msg "Installing ansible requirements for role ${BOLD}$role${RESET}"
    ansible-galaxy install -r "$requirement_file" > /dev/null
  done
}
