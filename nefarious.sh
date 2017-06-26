#nefarious things
echo "Starting nefariousness" > /data/local/tmp/rootme/root-log.txt
echo "Mounting system r/w" >> /data/local/tmp/rootme/root-log.txt 2>&1
mount -o remount,rw /system >> /data/local/tmp/rootme/root-log.txt 2>&1
echo "Copying files" >> /data/local/tmp/rootme/root-log.txt 2>&1
cp /data/local/tmp/rootme/su /system/xbin/ >> /data/local/tmp/rootme/root-log.txt 2>&1
chown 0:0 /system/xbin/su
chmod 6777 /system/xbin/su
#cp /data/local/tmp/rootme/busybox /system/bin/ >> /data/local/tmp/rootme/root-log.txt 2>&1
cp /data/local/tmp/rootme/SuperSU-v2.78.apk /system/app/ >> /data/local/tmp/rootme/root-log.txt 2>&1
echo "All done being nefarious, rebooting"
chown 2000:2000 /data/local/tmp/rootme/root-log.txt
chmod 666 /data/local/tmp/rootme/root-log.txt
sync
sync
mount -o remount,ro /system
