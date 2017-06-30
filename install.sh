#!/bin/sh

if [ "$1" = "" ]; then
	echo "Usage:   ./install.sh file.apk"
	exit 0
fi

uname=`uname`
echo "OS type: $uname"

echo "Getting signature of $1..."
if [ "$uname" = "Darwin" ]; then
	sig=`java -jar bin/GetAndroidSig.jar "$1" | grep "To char" | sed -E 's/^.{9}//'`
else
	sig=`java -jar bin/GetAndroidSig.jar "$1" | grep "To char" | sed -r 's/^.{9}//'`
fi
echo "Signature: $sig"

echo "Getting package information..."
if [ "$uname" = "Darwin" ]; then
	package=`aapt dump permissions "$1" | head -1 | sed -E 's/^.{9}//'`
else
	package=`aapt dump permissions "$1" | head -1 | sed -r 's/^.{9}//'`
fi
echo "Package name: $package"

echo "Backuping whitelist..."
adb shell "su -c 'chmod 666 /data/data/whitelist-1.0.xml'"
adb shell "cp /data/data/whitelist-1.0.xml /data/local/tmp/"
adb shell "su -c 'chmod 666 /data/local/tmp/whitelist-1.0.xml'"
adb pull /data/local/tmp/whitelist-1.0.xml whitelist-1.0.xml

echo "Preparing replacement whitelist"
cat whitelist-1.0.xml | grep  -v "</applicationLists" | grep -v "</whiteList" > whitelist-1.0-new.xml

echo "        <application>
            <property>
                <name>$package</name>
                <package>$package</package>
                <versionCode>1-999999999</versionCode>
                <keyStoreLists> " >> whitelist-1.0-new.xml
#Need to hanlde case of sig containing multiple lines - some APKS have more than one sig

for signature in $sig; do
echo "                    <keyStore>$signature</keyStore> " >> whitelist-1.0-new.xml

done

echo "                </keyStoreLists>
            </property>
            <controlData>
                <withAudio>without</withAudio>
                <audioStreamType>null</audioStreamType>
                <regulation>null</regulation>
                <revert>no</revert>
            </controlData>
        </application>

	</applicationLists>
</whiteList>" >> whitelist-1.0-new.xml

if [ ! -z "$sig" ]; then
	echo "APK signature obtained"
else
	echo "Error: APK signature NOT obtained!"
	exit 1
fi

if [ ! -z "$package" ]; then
	echo "Have package name: $package"
else
	echo "Error: Did not get package name!"
	exit 1
fi

wlcheck=`ls -al whitelist-1.0.xml | awk '{print $5}'`
if [ $wlcheck -gt 20000 ]; then
	echo "Original whitelist-1.0.xml size seems okay"
else
	echo "Error: Original whitelist-1.0.xml size DOES NOT seem okay!"
	exit 1
fi

packagecheck=`grep $package whitelist-1.0-new.xml`
if [ ! -z "$package" ]; then
	echo "Package name is present in new whitelist"
else
	echo "Error: Package name is NOT present in new whitelist!"
	exit 1
fi

ts=`date '+%Y-%m-%d--%H-%M-%S'`
echo "Backing up whitelist to /data/local/tmp/whitelist-1.0-$ts.xml"
adb shell "cp /data/data/whitelist-1.0.xml /data/local/tmp/whitelist-1.0-$ts.xml"
echo "Making an extra backup of whitelist on your PC..."
adb pull /data/local/tmp/whitelist-1.0-$ts.xml .

echo "Uploading whitelist to tmp..."
adb push whitelist-1.0-new.xml /data/local/tmp/whitelist-1.0-new.xml

adb shell "su -c 'cp /data/local/tmp/whitelist-1.0-new.xml /data/data/whitelist-1.0.xml'"
adb shell "su -c 'chown system:system /data/data/whitelist-1.0.xml'"
adb install -r $1
#adb push $1 /data/local/tmp/$1
#adb shell "su -c 'pm install -r /data/local/tmp/$1'"
