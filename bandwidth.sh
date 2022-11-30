#!/bin/bash
if [[ -n "$1" && -n "$2" ]];then
	if [[ "$2" -eq 0 ]];then
		interface=$(ifconfig | \grep -B5 172.29 | \grep ^en | cut -c 1-3)
		if [[ -z $interface ]];then
                  interface=$(ifconfig | \grep -B5 172.30 | \grep ^en | cut -c 1-3)
                fi
		if [[ -z $interface ]];then
                  interface=$(ifconfig | \grep -B5 10.38 | \grep ^en | cut -c 1-3)
                fi
	else
		interface=$2
	fi
	if [[ -z "$3" ]];then
		ip='Link'
	else
		ip="$3"
	fi
	if [[ "$1" == 0 ]];then
		dur="1"
		echo "Sampling bandwidth every $dur second"
		while :
		do
		start=$(netstat -b -I "$interface" | grep "$ip")
		startin=$(echo $start | awk '{ print $7 }')
		startout=$(echo $start | awk '{ print $10 }')
		sleep $dur
		end=$(netstat -b -I "$interface" | grep "$ip")
		endin=$(echo $end | awk '{ print $7 }')
		endout=$(echo $end | awk '{ print $10 }')

		indif="$(($endin-$startin))"
		outdif="$(($endout-$startout))"

		printf "\n%s KBps in\t%s KBps out" "$(($indif/$dur/1000))" "$(($outdif/$dur/1000))"
		done
	else 
		dur="$1"
		echo "Sampling bandwidth for $dur seconds on" $interface
		start=$(netstat -b -I "$interface" | grep "$ip")
		startin=$(echo $start | awk '{ print $7 }')
		startout=$(echo $start | awk '{ print $10 }')
		sleep $dur
		end=$(netstat -b -I "$interface" | grep "$ip")
		endin=$(echo $end | awk '{ print $7 }')
		endout=$(echo $end | awk '{ print $10 }')

		indif="$(($endin-$startin))"
		outdif="$(($endout-$startout))"

		printf "%s KBps in\t%s KBps out" "$(($indif/$dur/1000))" "$(($outdif/$dur/1000))"
		echo
	fi
elif [[ -n "$1" ]] && [[ -z "$2" || -z "$3" ]];then
	if [[ "$1" == "list" ]];then
		ifconfig
		exit 0
	elif [[ "$1" == "help" ]];then
		echo "Usage: ./bandwidth.sh seconds(0 for infinite) interface"
		exit 0
	fi
else
	echo "Usage: ./bandwidth.sh seconds(0 for infinite) interface"
	exit 1
fi
