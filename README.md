# live interface stats

a web based animated interactive graph showing network traffic


# how it works

a simple background process updates a file on a web server which
contains a set of values; the sparklines javascript magic running
in a static webpage grabs those values at intervals and makes a
scrolling graph.

In this demo, the values are network traffic readings of bytes and
packets, found by using snmp to get the interface metrics on the
localhost. There's no reason why the background process needs to
find the stats for the localhost, it could be a router, switch or
firewall, anything that supports snmp.

If you're more adventurous, you can get the metrics some other way,
all you need is to be able to write the values to a file which the
web page can access over http/https.


# Deployment

## Web page
Copy/rename the html file into a place where it can be accessed by a web
browser, giving it a name to reflect the interface being monitored, and
change the name of the interface data file to reflect the interface name
you'll be monitoring.

```
$ sudo mkdir /var/www/html/live_interface_stats
$ sudo cp live_interface_stats.html /var/www/html/live_interface_stats_ppp0.html
$ sudo vi /var/www/html/live_interface_stats_ppp0.html
```

## Background daemon

Copy the script to a suitable place like /usr/local/sbin where it can 
be run as a daemon.

Modify the script to set the DATADIR to the directory where the web page
is stored, so that the client running the javascript can retrieve the
bandwidth file; change the HOST if it's interrogating a different host
from itself

```
$ sudo mkdir -p /usr/local/sbin
$ sudo cp live_interface_stats.sh /usr/local/sbin/
$ cd /usr/local/sbin/
$ sudo vi live_interface_stats.sh
```

maybe run the script in a tmux session:
```
$ cd /usr/local/sbin/
$ tmux
...
$ ./live_interface_stats.sh ppp0
```

check that it's updating the DATADIR/DATAFILE file:
```
$ watch cat /var/run/live_interface_stats/old_stats_ppp0.dat
```


# Viewing the graphs

Open the html file in your browser and you should see the following
animated graph:

![Interface graph](https://github.com/speculatrix/live_interface_stats/raw/main/live_interface_stats.png)


