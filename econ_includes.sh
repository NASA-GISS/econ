
set -o nounset
set -o pipefail
set -o errexit
set -o errtrace

PROGNAME=$(basename "$0")
red='\033[0;31m'; orange='\033[0;33m'; green='\033[0;32m'; yellow='\033[0;93m'; nc='\033[0m' # No Color
log_info() { if [[ "${verbose:-}" == 1 ]]; then echo -e "${green}[$(date --iso-8601=seconds)] [INFO] [${PROGNAME}] ${*}${nc}" >&2; fi; }
log_warn() { echo -e "${orange}[$(date --iso-8601=seconds)] [WARN] [${PROGNAME}] ${*}${nc}" >&2; }
log_err() { echo -e "${red}[$(date --iso-8601=seconds)] [ERR] [${PROGNAME}] ${*}${nc}" >&2; }
log_debug() { if [[ ${debug:-} == 1 ]]; then echo -e "${yellow}[$(date --iso-8601=seconds)] [DEBUG] [${PROGNAME}] ${*}${nc}" >&2; fi }

err_exit() {
  # Use for fatal program error
  # Argument:
  #   optional string containing descriptive error message
  #   if no error message, prints "Unknown Error"
  echo -e "${red}[$(date --iso-8601=seconds)] [ERR] [${PROGNAME}] ${*:-"Unknown Error"}${nc}" >&2;
  exit 1
}

trap backtrace ERR
function backtrace () {
    local deptn=${#FUNCNAME[@]}
    for ((i=1; i<deptn; i++)); do
        local func="${FUNCNAME[$i]}"
        local line="${BASH_LINENO[$((i-1))]}"
        local src="${BASH_SOURCE[$((i-1))]}"
        printf '%*s' "$i" '' # indent
        log_err "at: $func(), $src, line $line"
    done
}

