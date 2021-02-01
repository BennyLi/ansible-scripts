#! /usr/bin/env bash

function setup_virtualenv() {
  if [ -f $PROJECT_ROOT/$PYTHON_VIRTUAL_ENV_NAME/bin/activate ]
  then
    display_msg "Python virtual env ${BOLD}$PYTHON_VIRTUAL_ENV_NAME${RESET} already exits"
  else
    python -m venv $PYTHON_VIRTUAL_ENV_NAME
  fi
  display_msg "Activating Python virtual env ${BOLD}$PYTHON_VIRTUAL_ENV_NAME${RESET} ..."
  source $PROJECT_ROOT/$PYTHON_VIRTUAL_ENV_NAME/bin/activate

  python -m pip install --upgrade pip > /dev/null
}
