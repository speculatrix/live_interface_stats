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

Copy/rename the html file into a place where it can be accessed by a web
browser, giving it a name to reflect the interface being monitored

Modify the script to set the DATADIR to the directory where the web page
is stored, so that the client running the javascript can retrieve the
bandwidth file; change the HOST if it's interrogating a different host
from itself

Run the script in a tmux or screen session, check that it's updating the
DATADIR/DATAFILE file

Open the html file in your browser and you should see the following
animated graph:

![Interface graph](https://github.com/speculatrix/live_interface_stats/raw/main/live_interface_stats.png)


