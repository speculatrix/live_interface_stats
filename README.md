# live_interface_stats
a web based animated interactive graph showing network traffic


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

![Interface graph](https://raw.githubusercontent.com/speculatrix/live_interface_stats/master/live_interface_stats.png)


