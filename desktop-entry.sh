#!/bin/bash

if ! which xdg-desktop-menu > /dev/null 2>&1; then
  echo "[$0] missing xdg-desktop-menu, quitting"
  exit 1
fi

case "${1}" in --current-app|-ca|--current-app-continue|-cac)
  APP_ID=$(adb shell dumpsys activity activities | \
    grep ResumedActivity | \
    awk '{print $4}' | \
    tail -1 | \
    sed 's|/|\n|g' | \
    head -1)
  echo "APP_ID: ${APP_ID}"
  case "${1}" in 
    --current-app-continue|-cac)
      export APP_ID
      export TITLE="$(echo ${APP_ID} | tr '.' '\n' | tail -1)"
    ;;
    *) exit 0 ;;
  esac
esac

case "${APP_ID}" in "")
  read -p 'APP_ID (full package ID of app): ' APP_ID
;; esac
case "${DEVICE_PIN}" in "")
  read -p '[optional] DEVICE_PIN (the code you unlock your phone with): ' DEVICE_PIN
;; esac
case "${DEVICE_IP}" in "")
  read -p '[optional] DEVICE_IP (local ip of device with port suffix): ' DEVICE_IP 
case "${TITLE}" in "")
  read -p '[optional] TITLE (window title string): ' TITLE
;; esac
case "${COMMENT}" in "")
  read -p '[optional] COMMENT (xdg-desktop comment): ' COMMENT
;; esac

ENTRY="${USER}-${TITLE}.desktop"

cat >> "${ENTRY}" << EOF
[Desktop Entry]
Type=Application
Name=${TITLE}
Comment=${COMMENT}
Exec=bash -c 'APP_ID="${APP_ID}" TITLE="${TITLE}" DEVICE_PIN="${DEVICE_PIN}" DEVICE_IP="${DEVICE_IP}" aal'
Icon=scrcpy
Terminal=False
Categories=Utilities
StartupNotify=false
EOF
cat "${ENTRY}"

echo "installing ${ENTRY}"
xdg-desktop-menu install "${ENTRY}"

rm -f "${ENTRY}"
