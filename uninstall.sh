#!/usr/bin/env bash
set -e

APP_NAME="filebrowser"
BIN_DIR="/usr/local/bin"
CONFIG_DIR="/etc/filebrowser_quantum"
SERVICE_FILE="/etc/systemd/system/filebrowser_quantum.service"
STORAGE_BASE="/filebrowser_quantum_storage"
LOG_FILE="/var/log/filebrowser_quantum.log"

echo "==============================="
echo "FileBrowser Quantum Uninstaller"
echo "==============================="

if systemctl list-units --all | grep -q filebrowser_quantum.service; then
    echo "Stopping service..."
    sudo systemctl stop filebrowser_quantum.service || true
    sudo systemctl disable filebrowser_quantum.service || true
fi

if [ -f "${SERVICE_FILE}" ]; then
    echo "Removing systemd service..."
    sudo rm -f "${SERVICE_FILE}"
    sudo systemctl daemon-reload
fi

if [ -f "${BIN_DIR}/${APP_NAME}" ]; then
    echo "Removing binary..."
    sudo rm -f "${BIN_DIR}/${APP_NAME}"
fi

if [ -d "${CONFIG_DIR}" ]; then
    echo "Removing config directory..."
    sudo rm -rf "${CONFIG_DIR}"
fi

if [ -d "${STORAGE_BASE}" ]; then
    echo
    echo "Storage directory detected:"
    echo "  ${STORAGE_BASE}"
    echo "This contains ALL user/admin/shared files!"
    echo
    read -rp "Do you want to DELETE the storage directory? (yes/NO): " CONFIRM

    if [[ "${CONFIRM}" == "yes" ]]; then
        echo "Deleting storage directory..."
        sudo rm -rf "${STORAGE_BASE}"
        echo "Storage directory removed."
    else
        echo "Storage directory preserved."
    fi
fi

if [ -f "${LOG_FILE}" ]; then
    echo "Removing log file..."
    sudo rm -f "${LOG_FILE}"
fi

echo
echo "======================================="
echo "FileBrowser Quantum uninstall completed"
echo "======================================="
