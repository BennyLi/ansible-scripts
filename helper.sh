#! /bin/bash

# Formatting options {{{1
# See also
#   * https://linux.101hacks.com/ps1-examples/prompt-color-using-tput/

BOLD="$(tput bold)"
RESET="$(tput sgr0)"

# Color options {{{2

function fromhex(){
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})
    printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 +
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

RED="$(tput setaf 160)"     # HEX color: #e31414
YELLOW="$(tput setaf 178)"  # HEX color: #c9ad0a
BLUE="$(tput setaf 033)"    # HEX color: #0a99fc



# Logging helper {{{1

display_msg() {
  echo -e "${BLUE}> [INFO]${RESET}   $@"
}

display_warn() {
  echo -e "${YELLOW}! [WARN]   $@${RESET}"
}

display_error() {
  echo -e "${RED}X [ERROR]  🚨 $@ 🚨${RESET}"
}
