#!/bin/bash

while :
do
	p=`ps -ef | wc -l` 
	
	if [ "${p}" -ge 75 ]
	then
		echo ${p}
		killall -9 launch_traceroute.sh
	fi

	sleep 45 
done

