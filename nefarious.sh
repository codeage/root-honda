#nefarious things
echo "Starting nefariousness"

echo "Mounting system r/w"
mount -o remount,rw,sync /system

echo "Copying files"
cp /data/local/tmp/rootme/su /system/xbin/
chown 0:0 /system/xbin/su
chmod 6777 /system/xbin/su

cp /data/local/tmp/rootme/SuperSU-v2.78.apk /system/app/

echo "Mounting system r/o"
echo "Success"
mount -o remount,ro /system
