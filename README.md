# live interface stats

a web based animated interactive graph showing network traffic


# licence

my code is released under the GPLv3

the jquery sparklines project released their code under the 
<a href="https://opensource.org/licenses/BSD-3-Clause">New BSD licence</a>
and was copied and adapted to make this work.


# screenshot of graph

Open the html file in your browser and you should see the following
animated graph; the graph slides to the left, and you can hover the
mouse to see values. The grey area is the range defined by the
server, so you can see where there's high load.

![Interface graph](https://github.com/speculatrix/live_interface_stats/raw/main/live_interface_stats.png)


# how it works

## client side
The end user opens an HTML page which loads some javascript, and 
that generates the animated graph, all the heavy lifting is done
on the client side. The javascript polls a file on the web server
which provides the measurements to be graphed.

## server side

A simple background process updates a file on a web server which
contains a set of values. This means that you can have many people
viewing the graphs without overloading the server, because they 
are only fetching a file which imposes minimal load.

Since they are not running a cgi-bin program there's no security 
risk other than having a web server available.

## client side

The "sparklines" javascript was adapted to grab values from a
web site, and make scrolling graphs.

In this values are network traffic readings of bytes and
packets, found by using snmp to get the interface metrics on the
localhost. There's no reason why the background process needs to
find the stats for the localhost, it could be a router, switch or
firewall, anything that supports snmp.

If you're more adventurous, you can get the metrics some other way,
all you need is to be able to write the values to a file which the
web server can server over http/https.


# Deployment

## Web page

Grab jquery.js from https://github.com/jquery/jquery/blob/main/src/jquery.js

Grab jquery.sparkline.js from https://omnipotent.net/jquery.sparkline/2.1.2/jquery.sparkline.js

Copy jquery.js and the html file into a place where it can be accessed by a web
browser, giving it a name to reflect the interface being monitored, and
change the name of the interface data file to reflect the interface name
you'll be monitoring.

These commands slightly tweaked should do what you need:
```
$ sudo mkdir -p /var/www/html/live_interface_stats
$ sudo cp live_interface_stats.html /var/www/html/live_interface_stats/live_interface_stats_ppp0.html
$ cd /var/www/html/live_interface_stats
$ sudo wget https://github.com/jquery/jquery/blob/main/src/jquery.js
$ sudo wget https://omnipotent.net/jquery.sparkline/2.1.2/jquery.sparkline.js
$ sudo vi live_interface_stats_ppp0.html
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

maybe run the script in a tmux session (Screen would also do):
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



# Acknowledgements

This would not have been possible with this the <a href="https://omnipotent.net/jquery.sparkline/#s-about">jQuery Sparklines</a> project
from whom this work was adaptored (namely the mouse velocity example).


