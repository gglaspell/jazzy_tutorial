#!/bin/bash
# setup_sros2.sh
# Creates an SROS2 keystore and generates enclave keys for the
# talker/listener demo.  Safe to re-run: skips creation if the keystore
# already exists (determined by the presence of identity_ca.cert.pem,
# NOT by whether the directory is non-empty).
#
# Jazzy requirement: enclave names MUST be absolute paths (start with '/').

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
KEYSTORE_DIR="${SCRIPT_DIR}/keystore"

# Source ROS 2 if not already sourced
if [ -z "${ROS_DISTRO}" ]; then
    # shellcheck disable=SC1091
    source /opt/ros/jazzy/setup.bash
fi

echo "[setup_sros2] Keystore directory: ${KEYSTORE_DIR}"

# Check for a real keystore, NOT just a .gitkeep placeholder file
if [ -f "${KEYSTORE_DIR}/enclaves/identity_ca.cert.pem" ]; then
    echo "[setup_sros2] Keystore already exists — skipping creation."
else
    echo "[setup_sros2] Creating keystore..."
    ros2 security create_keystore "${KEYSTORE_DIR}"
fi

# Jazzy requires absolute enclave names (leading '/').  Non-absolute names
# are rejected with: "Security directory does not exist for enclave: ..."
ENCALVES=(
    "/talker_listener/talker"
    "/talker_listener/listener"
)

for ENCLAVE in "${ENCLAVES[@]}"; do
    # Enclave key directory: strip the leading '/' to form a relative path
    RELATIVE="${ENCLAVE#/}"
    ENCLAVE_PATH="${KEYSTORE_DIR}/enclaves/${RELATIVE}"
    if [ -f "${ENCLAVE_PATH}/cert.pem" ]; then
        echo "[setup_sros2] Enclave '${ENCLAVE}' already exists — skipping."
    else
        echo "[setup_sros2] Creating enclave: ${ENCLAVE}"
        ros2 security create_enclave "${KEYSTORE_DIR}" "${ENCLAVE}"
    fi
done

echo ""
echo "[setup_sros2] Done!  Next steps:"
echo "  1. Source the environment:  source ${SCRIPT_DIR}/secure_env.sh"
echo "  2. Run the talker (Terminal A):"
echo "       ros2 run demo_nodes_cpp talker --ros-args --enclave /talker_listener/talker"
echo "  3. Run the listener (Terminal B):"
echo "       ros2 run demo_nodes_py listener --ros-args --enclave /talker_listener/listener"
