#!/bin/bash
WORKSPACE=/mnt/sdcard
TIMEZONE=Asia/Shanghai

#apk name
apk=$1
b=$(($RANDOM%500))
c=$((($RANDOM%20)+25))
package="com.ifeng.news2"

#######################################################################################################
date > ${WORKSPACE}/shell_start_time.ini
#######################################################################################################

echo "active.sh is running!"
busybox rm -r ${WORKSPACE}/scripts/userdata/*
busybox rm -r ${WORKSPACE}/scripts/shell/mnt


#busybox tar xzvf /mnt/sdcard/scripts/userdata.tar.gz -C /mnt/sdcard/scripts/shell/
busybox tar xzvf ${WORKSPACE}/scripts/userdata.tar.gz -C /mnt/sdcard/scripts/shell/
#two img file named userdata.img / userdata-qemu.img in the package

#?????????????????????what the fuck is this?
#busybox cp -r  /mnt/sdcard/scripts/shell/mnt/sdcard/scripts/userdata/*  /mnt/sdcard/scripts/userdata/
busybox cp -r ${WORKSPACE}/scripts/userdata/*  /mnt/sdcard/scripts/userdata/
am force-stop $package
pm install -r ${WORKSPACE}/$apk

busybox  cp -r /mnt/sdcard/scripts/userdata/* /data/data/$package/
busybox chmod -R 777 /data/data/$package/*
#########################################  function  ###################################################

#LOCALWIDTH=($(busybox sed -n '1,1p' /mnt/sdcard/cellwidth.ini))
#LOCALHEIGHT=($(busybox sed -n '1,1p' /mnt/sdcard/cellheight.ini))

LOCALWIDTH=($(busybox sed -n '1,1p' ${WORKSPACE}/scripts/cellwidth.ini))
LOCALHEIGHT=($(busybox sed -n '1,1p' ${WORKSPACE}/scripts/cellheight.ini))

killmonkey()
{
	busybox killall com.android.commands.monkey
}

startapp()
{
	killmonkey
	monkey -v -s $b -p $package  --throttle 4000 --pct-touch 100 --ignore-crashes --ignore-timeouts --ignore-security-exceptions 1
}

send_back()
{
	input keyevent KEYCODE_BACK
	echo "send_back"
}

send_point()
{
 	input tap $1 $2
 	echo "x=$1 y=$2"
}

send_randompoint()
{
	local x1=$1
	local x2=$2
	local y1=$3
	local y2=$4
	local delt_x
  local delt_y
  local fin_x
	local fin_y
	
	let delt_x=x2-x1
	let delt_y=y2-y1
	
	if [ "$delt_x" = "0" ];then 
		delt_x=1
	fi
	
	if [ "$delt_y" = "0" ];then 
		delt_y=1
	fi
	
	fin_x=$((($RANDOM%$delt_x)+$x1))
	fin_y=$((($RANDOM%$delt_y)+$y1))
	
	send_point $fin_x $fin_y
}


send_slide()
{
	local direction=$1
	local slide_number=$2
	
	local width_0_4=$((($LOCALWIDTH*0/4)+0))
	local width_1_4=$((($LOCALWIDTH*1/4)+0))
	local width_2_4=$((($LOCALWIDTH*2/4)+0))
	local width_3_4=$((($LOCALWIDTH*3/4)+0))
	local width_4_4=$((($LOCALWIDTH*4/4)-1))
	
	local height_0_4=$((($LOCALHEIGHT*0/4)+0))
	local height_1_4=$((($LOCALHEIGHT*1/4)+0))
	local height_2_4=$((($LOCALHEIGHT*2/4)+0))
	local height_3_4=$((($LOCALHEIGHT*3/4)+0))
	local height_4_4=$((($LOCALHEIGHT*4/4)-1))

	local i	
	for((i=0;i<$slide_number;i++));do
	
		if [ "$direction" = "1" ];then			
			input swipe $width_2_4 $height_3_4 $width_2_4 $height_0_4
		fi
		
		if [ "$direction" = "2" ];then
			input swipe $width_2_4 $height_1_4 $width_2_4 $height_4_4
		fi
		
		if [ "$direction" = "3" ];then
			input swipe $width_3_4 $height_2_4 $width_0_4 $height_2_4
		fi
	
		if [ "$direction" = "4" ];then
			input swipe $width_1_4 $height_2_4 $width_4_4 $height_2_4
		fi
	
		sleep 3s
	done
}

send_random_event()
{
  	local times=$1
	local i
	
	startapp		
	sleep 5s

	for((i=0;i<$times;i++));do
	
		local random=$((($RANDOM%10)+1))
		local point_x=$(($RANDOM%$LOCALWIDTH+0))
		local point_y=$(($RANDOM%$LOCALHEIGHT+0))

		
		if [ $random -gt 2 ];then
			  send_point $point_x $point_y
		else		
				local direction=$((($RANDOM%4)+1))
				random=$((($RANDOM%4)+1))
				send_slide $direction $random	
		fi
		
		random=$((($RANDOM%4)+4))
		sleep $random
		
		random=$((($RANDOM%10)+1))
		if [ "$random" = "1" ];then
			send_back
			sleep 3s
		fi
		
		echo "i = $i"
	done

}

start_monkey_event()
{
	b=$(($RANDOM%500))
	killmonkey
	monkey -v -s $b -p $package  --throttle 6000 --ignore-crashes --ignore-timeouts --ignore-security-exceptions $1
}

always_cmnet()
{
	busybox sed -i '/conn_type=/d' /data/config.ini
	busybox sed -i '/conn_type_name=/d' /data/config.ini
	busybox sed -i '/conn_extra=/d' /data/config.ini
	
	busybox echo 'conn_type=0' >> /data/config.ini
	busybox echo 'conn_type_name=MOBILE' >> /data/config.ini
	busybox echo 'conn_extra=cmnet' >> /data/config.ini
}


inputex()
{
	local times=$(($RANDOM%$6))
	
	for((i=0;i<$times;i++));do
	
		if [ "$1" = "swipe" ];then
			input swipe $2 $3 $4 $5
			sleep 1s
		fi
		
	done
}

sleepex()
{
	local times=$(($RANDOM%$2))
	local random=$((($RANDOM%2)+0))
	local totaltime=0
	if [ "$random" = "1" ];then
		totaltime=$(($1+$times))
	else
		totaltime=$(($1-$times))
	fi
	
	sleep $totaltime
	echo "sleep time=$totaltime"
}

#######################################################################################################
startapp
	
	sleep 25s
	
	
	
	send_point 260 400
	sleep 5s
	

	

	
	dosomething()
	{
	
		random=$((($RANDOM%5)+0))
	echo "random=$random"
	if [ "$random" = "1" ];then
		echo "do nothing"
	else	
		if [ "$random" = "2" ];then
				input swipe 300 300 10 300
		else
				for((i=0;i<6;i++));do
				
					input swipe 300 300 10 300
				
				done
		fi
		
	fi	
	

	
	sleep 10s
	
		send_slide 1 $((($RANDOM%6)+0))	
		
		sleep 8s
		
		send_randompoint 0 480 120 420
		send_randompoint 0 480 120 420
		
		sleep 18s
		
		
		send_slide 1 $((($RANDOM%8)+4))	
		
		sleep 3s
		
		send_back
		
		sleep 5s
		
		send_slide 1 $((($RANDOM%6)+0))	
		
		sleep 8s
		
		send_randompoint 0 480 120 420
		send_randompoint 0 480 120 420
		
		sleep 18s
		
		
		send_slide 1 $((($RANDOM%8)+4))	
		
		sleep 3s
		
		send_back
		
		
		
		
		
	}
	
  dosomething
  dosomething


	start_monkey_event 8
	
	
#######################################################################################################

:<<BLOCK'
	echo "scripts  end"
	startapp
	sleep 3s	
#######################################################################################################
echo "update  is running!"
busybox  cp -r /data/data/$package/* /mnt/sdcard/scripts/userdata/
busybox rm -r /mnt/sdcard/scripts/userdata/cache/
busybox rm -r /mnt/sdcard/scripts/userdata/lib/
busybox rm -r /mnt/sdcard/scripts/userdata/libs/
busybox rm  /mnt/sdcard/scripts/userdata.tar.gz
busybox tar czvf /mnt/sdcard/scripts/userdata.tar.gz /mnt/sdcard/scripts/userdata/*
BUSINESSID=($(busybox sed -n '1,1p' /mnt/sdcard/businessid.ini))
LOCALIP=($(busybox sed -n '1,1p' /mnt/sdcard/localip.ini))
LOCALMAC=($(busybox sed -n '1,1p' /mnt/sdcard/localmac.ini))
CELLID=($(busybox sed -n '1,1p' /mnt/sdcard/cellid.ini))
apkcount=($(busybox ps -ef | busybox grep -c $package))
echo "apkcount"
echo "$apkcount"
if [ "$apkcount" != "1" ];then
curl --connect-timeout 20 -m 60 -F upload=@/mnt/sdcard/scripts/userdata.tar.gz -F ID="$BUSINESSID" -F LOCAL_IP="$LOCALIP" -F LOCAL_MAC="$LOCALMAC" -F CELL_ID="$CELLID" http://192.168.1.2:4501/IF/SIM/sim_main_result.aspx  >> /mnt/sdcard/scripts/exception.log
fi
#######################################################################################################
cat /mnt/sdcard/shell_start_time.ini
date
#######################################################################################################

am force-stop $package	


echo "active - done"
'BLOCK