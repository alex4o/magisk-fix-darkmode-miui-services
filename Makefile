pull:
	adb shell "su -c cat /system/framework/services.jar" > services.apk

update:
	java -jar ../smali-2.4.0.jar a out -o classes.dex
	zip MiuiSystemUI.apk classes*.dex

push:
	adb shell "su -c mount -o remount,rw /"
	adb push services.apk /data/local/tmp
	adb shell "su -c mv /data/local/tmp/services.apk /system/framework/services.jar"
