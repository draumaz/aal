#/bin/bash -e
# Android app launcher, a scrcpy wrapper

case "$(adb devices | sed 1d)" in
  "")
    case "${DEVICE_IP}" in
      *":"*)
        adb connect "${DEVICE_IP}"
      ;;
      "")
        echo "[$0] no device connected or IP provided, exiting"
        exit 1
      ;;
    esac
esac

LOCK_STATE=$(
  adb shell dumpsys window | \
    sed 's/ /\n/g' | \
    grep 'mDreamingLockscreen' | \
    sed 's/=/\n/g' | \
    tail -1
)

echo "[$0] device locked: ${LOCK_STATE}"

ORIG_ACTIVITY=$(
  adb shell dumpsys activity activities | \
    grep ResumedActivity | \
    awk '{print $4}' | \
    tail -1 | \
    sed 's|/|\n|g' | \
    head -1
)

echo "[$0] current activity: ${ORIG_ACTIVITY}"

case "${APP_ID}" in "")
  echo "[$0] no APP_ID provided"
  exit 1
;; esac

case "${LOCK_STATE}" in
  true)
    case "${DEVICE_PIN}" in "")
      echo "[$0] no DEVICE_PIN provided; cannot unlock device"
      exit 1
    ;; esac

    echo "[$0] unlocking your device"

    adb shell " 
      # Wake device from sleep
      input keyevent 26 && sleep 0.35
      # Simulate swipe up to get to pinpad
      input swipe 500 1500 500 500 && sleep 0.1
      # Type pincode to unlock device
      input text ${DEVICE_PIN}
    "
;; esac

case "${TITLE}" in "") TITLE="${APP_ID}" ;; esac

echo "[$0] running scrcpy, opening ${APP_ID}"

scrcpy \
  --always-on-top \
  --no-audio \
  --turn-screen-off \
  --window-title="${TITLE}" \
  --start-app="${APP_ID}" \
    > /dev/null 2>&1

case "${ORIG_ACTIVITY}" in
  "${APP_ID}") ;;
  *)
    echo "[$0] reopening ${ORIG_ACTIVITY}"
    adb shell "monkey -p ${ORIG_ACTIVITY} 1" > /dev/null 2>&1
  ;;
esac

case "${LOCK_STATE}" in "true")
  echo "[$0] locking device"
  adb shell "input keyevent 223" ;;
esac
