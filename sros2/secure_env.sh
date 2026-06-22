#!/bin/bash
# secure_env.sh
# Source this file to enable SROS2 security for the current terminal session.
# Usage (from inside the container):  source /home/ros2_ws/../sros2/secure_env.sh
#   or, if you bind-mounted the repo root to /workspace:
#          source /workspace/sros2/secure_env.sh
#
# The keystore must already exist.  Run setup_sros2.sh first if it does not.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYSTORE_DIR="${SCRIPT_DIR}/keystore"

if [ ! -f "${KEYSTORE_DIR}/enclaves/identity_ca.cert.pem" ]; then
    echo "[secure_env] ERROR: Keystore not found at ${KEYSTORE_DIR}."
    echo "             Run './sros2/setup_sros2.sh' first."
    return 1
fi

export ROS_SECURITY_KEYSTORE="${KEYSTORE_DIR}"
export ROS_SECURITY_ENABLE=true
export ROS_SECURITY_STRATEGY=Enforce

echo "[secure_env] SROS2 security enabled."
echo "  ROS_SECURITY_KEYSTORE  = ${ROS_SECURITY_KEYSTORE}"
echo "  ROS_SECURITY_ENABLE    = ${ROS_SECURITY_ENABLE}"
echo "  ROS_SECURITY_STRATEGY  = ${ROS_SECURITY_STRATEGY}"
