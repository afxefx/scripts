#!/bin/bash
if [[ "$1" == 0 ]];then
	dur="1"
	echo "Sampling bandwidth every $dur second"
	while :
	do
	start=$(netstat -b -I "$2" | grep "$3")
	startin=$(echo $start | awk '{ print $7 }')
	startout=$(echo $start | awk '{ print $10 }')
	sleep 1
	end=$(netstat -b -I "$2" | grep "$3")
	endin=$(echo $end | awk '{ print $7 }')
	endout=$(echo $end | awk '{ print $10 }')

	indif="$(($endin-$startin))"
	outdif="$(($endout-$startout))"

	printf "\n%s KBps in\t%s KBps out" "$(($indif/$dur/1000))" "$(($outdif/$dur/1000))"
	done
elif [[ "$1" == "list" ]];then
	ifconfig
elif [[ "$1" == "help" ]];then
	echo "Usage: ./bandwidth.sh duration interface ip"
else 
	dur="$1"
	start=$(netstat -b -I "$2" | grep "$3")
	startin=$(echo $start | awk '{ print $7 }')
	startout=$(echo $start | awk '{ print $10 }')
	sleep $dur
	end=$(netstat -b -I "$2" | grep "$3")
	endin=$(echo $end | awk '{ print $7 }')
	endout=$(echo $end | awk '{ print $10 }')

	indif="$(($endin-$startin))"
	outdif="$(($endout-$startout))"

	printf "%s KBps in\t%s KBps out" "$(($indif/$dur/1000))" "$(($outdif/$dur/1000))"
fi


