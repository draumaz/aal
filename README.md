# aal
## Android App Launcher, a scrcpy wrapper
- Open an app on your Android device and use it seamlessly on your PC, similar to Apple's iPhone Mirroring feature.
- Your device's screen will blacken during use.

## Usage
- Device is unlocked: ```APP_ID="com.fitbit.FitbitMobile" sh aal.sh```
- Device is asleep/locked: ```DEVICE_PIN="Your 4-6 digit pin" APP_ID="com.fitbit.FitbitMobile" sh aal.sh```
  - aal will use [dark magic](https://gist.github.com/arjunv/2bbcca9a1a1c127749f8dcb6d36fb0bc) to automate waking and unlocking your device.
  - An optional ```DEVICE_IP``` variable is available to automatically connect to your device if you're using the [magisk-wifiadb](https://github.com/mrh929/magisk-wifiadb) module.

- As with vanilla scrcpy, you may replace the ```APP_ID``` package ID with a conventional name of the app prefixed with a question mark, such as ```APP_ID="?fitbit"```.

## Demonstration
![Screenshot of the Fitbit app's homescreen being displayed through aal](https://github.com/draumaz/aal/blob/main/media/fitbit_home.png)

- It's fully interactive with keyboard and mouse.
- When you close aal, you will return to the previously open app. Otherwise, the device will go back to sleep.

## Prerequisites

- Android phone with scrcpy installed and ADB debugging over Wifi enabled
- PC with scrcpy installed and an active wireless ADB debugging connection
  - Check: ```adb devices```

# Install

- aal is just a shell script; make it an executable and put it somewhere in your path.
```
export DEST="/wherever/you/want"
{ echo $PATH | grep "${DEST}" > /dev/null 2>&1 && echo "Good to go!"; } \
  || echo "Not that one."

sudo curl -fL https://raw.githubusercontent.com/draumaz/aal/refs/heads/main/aal.sh > "${DEST}/aal"
sudo chmod -v +x "${DEST}/aal"
unset DEST
```
