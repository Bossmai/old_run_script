#!/bin/bash
TIMEZONE=Asia/Shanghai

#some path, don't know what it is used for
mypath="/data/data/com.autonavi.minimap"

#passed into the script. may be the target apk package name
apk=$1

package=com.autonavi.minimap
echo $apk
echo $package

b=$(($RANDOM%500))


#busybox rm -r /mnt/sdcard/scripts/userdata/*

#busybox rm -r /mnt/sdcard/scripts/shell/mnt

#busybox tar xzvf /mnt/sdcard/scripts/userdata.tar.gz -C /mnt/sdcard/scripts/shell/

#busybox cp -r  /mnt/sdcard/scripts/shell/mnt/sdcard/scripts/userdata/*  /mnt/sdcard/scripts/userdata/

busybox tar xzvf /mnt/sdcard/scripts/userdata.tar.gz -C /

am force-stop com.autonavi.minimap

chmod 777 '/mnt/sdcard/apps/'$apk
pm install -r '/mnt/sdcard/apps/'$apk

monkey -v -s $b -p $package --throttle 4000 --pct-touch 70  --pct-motion 30 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 1
sleep 5s
am force-stop $package


#busybox  cp -r /mnt/sdcard/scripts/userdata/* /data/data/com.autonavi.minimap/
busybox tar xzvf /mnt/sdcard/scripts/userdata.tar.gz -C /

busybox chmod -R 777 /data/data/com.autonavi.minimap/*


sleep 2s

monkey -v -s $b -p com.autonavi.minimap --throttle 4000 --pct-touch 70  --pct-motion 30 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 1

sleep 15s

sendevent /dev/input/event0 3 0 160
sendevent /dev/input/event0 3 1 260
sendevent /dev/input/event0 1 330 1 
sendevent /dev/input/event0 0 0 0 
sendevent /dev/input/event0 1 330 0 
sendevent /dev/input/event0 0 0 0 


sleep 5s

sendevent /dev/input/event0 3 0 160
sendevent /dev/input/event0 3 1 50
sendevent /dev/input/event0 1 330 1 
sendevent /dev/input/event0 0 0 0 
sendevent /dev/input/event0 1 330 0 
sendevent /dev/input/event0 0 0 0 


sleep 1s

monkey -v -s $b -p com.autonavi.minimap  --throttle 5000 --pct-touch 60  --pct-motion 40 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 20

sendevent /dev/input/event0 1 158 1 &&  sendevent /dev/input/event0 1 158 0

sleep 2s

monkey -v -s $b -p com.autonavi.minimap  --throttle 5000 --pct-touch 60  --pct-motion 40 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 20

sendevent /dev/input/event0 1 158 1 &&  sendevent /dev/input/event0 1 158 0
sleep 2s

monkey -v -s $b -p com.autonavi.minimap  --throttle 5000 --pct-touch 60  --pct-motion 40 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 20



busybox  cp -r /data/data/com.autonavi.minimap/* /mnt/sdcard/scripts/userdata/

busybox rm -r /mnt/sdcard/scripts/userdata/cache/
busybox rm -r /mnt/sdcard/scripts/userdata/lib/


busybox rm  /mnt/sdcard/scripts/userdata.tar.gz

busybox tar czvf /mnt/sdcard/scripts/userdata.tar.gz /mnt/sdcard/scripts/userdata/*



BUSINESSID=($(busybox sed -n '1,1p' /mnt/sdcard/businessid.ini))

LOCALIP=($(busybox sed -n '1,1p' /mnt/sdcard/localip.ini))

LOCALMAC=($(busybox sed -n '1,1p' /mnt/sdcard/localmac.ini))

CELLID=($(busybox sed -n '1,1p' /mnt/sdcard/cellid.ini))

echo "$BUSINESSID"

echo "$LOCALIP"

echo "$LOCALMAC"

echo "$CELLID"


apkcount=($(busybox ps -ef | busybox grep -c com.autonavi.minimap))

echo "apkcount"
echo "$apkcount"

if [ "$apkcount" != "1" ];then

curl --connect-timeout 10 -m 60 -F upload=@/mnt/sdcard/scripts/userdata.tar.gz -F ID="$BUSINESSID" -F LOCAL_IP="$LOCALIP" -F LOCAL_MAC="$LOCALMAC" -F CELL_ID="$CELLID" http://192.168.1.2:4501/IF/SIM/sim_main_result.aspx  >> /mnt/sdcard/scripts/exception.log

fi


am force-stop com.autonavi.minimap

echo "active - done"









	
