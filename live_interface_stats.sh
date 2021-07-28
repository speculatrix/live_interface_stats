#!/bin/bash
# live_interface_stats.sh - use snmp to get stats from specified interface (or ppp0 by default)
# and writes the values to a file so that sparklines can plot a live graph


if [ "$1" != "" ] ; then
	IFNAME="$1"
	echo "Info, user chose interface $IFNAME"
else
	IFNAME="ppp0"
	echo "Info, defaulting to interface $IFNAME"
fi


HOST=127.0.0.1

DATADIR="/var/run/palin_stats_$IFNAME"
DATAFILE="$DATADIR/old_stats.dat"
BWFILE="/var/www/public/htdocs/firewall/firewall_bandwidths_$IFNAME.txt"


# Y axis params for the web page - rate is octets per second
MAXOUTBPS=2000000
MAXINBPS=9000000
MAXPPS=10000

DELAY=2	# delay between measurements - tasker fetches every 2 minutes
DEBUG=0

if [ "$1" == "-d" ] ; then
	DEBUG=1
	echo "Debug enabled"
fi

let W=0
let X=0
let Y=0
let Z=0


#########################################
function get_stats()
{
	local IFNUM="$1"
	read W X Y Z < <( snmpget -v2c -c public -OQ -Ov "$HOST" "IF-MIB::ifInOctets.$IFNUM" "IF-MIB::ifOutOctets.$IFNUM" "IF-MIB::ifInUcastPkts.$IFNUM" "IF-MIB::ifOutUcastPkts.$IFNUM"  | tr "\n" " " )
}


#########################################
# main

# find the interface
IFNUM=`snmpwalk -v2c -c public localhost .1.3.6.1.2.1.2.2.1.2 | grep "$IFNAME" | sed -re 's/IF-MIB::ifDescr\.([0-9]*) .*$/\1/'`
if [ "$IFNUM" == "" ] ; then
	echo "Error, failed to find the interface"
	exit 1
fi


if [ ! -f $DATAFILE ] ; then
	mkdir -p $DATADIR
fi

# baseline stats
get_stats "$IFNUM"
echo "$W $X $Y $Z" > $DATAFILE
sleep $DELAY

# loop poll
while [ /bin/true ] ; do

	if [ -f "$DATAFILE" ] ; then
		# get previous values
		read A B C D < $DATAFILE

		get_stats "$IFNUM"

		[ $DEBUG == 1 ] && echo "W X Y Z $W $X $Y $Z" >&2
		echo "$W $X $Y $Z" > $DATAFILE

		echo $DELAY $MAXINBPS $(( $W - $A )) $MAXOUTBPS $(( $X - $B )) $MAXPPS $(( $Y - $C )) $MAXPPS $(( $Z - $D )) > $BWFILE

		[ $DEBUG == 1 ] && echo "loop" >&2
	fi

	sleep $DELAY
done

# end live_interface_stats.sh
