Internet Drop Checker
=====================

This is a perl script that detects a dropped internet connection before the cable modem can notice something's fucky (if it ever does).  It was created in a fit of incoherent rage and may be contain more bugs than lines of working code.

It requires a Motorola cable modem, or something else that will restart when anyone or anything behind the modem sends an HTTP GET to http://192.168.100.1/reset.htm, Net::Ping, LWP::Simple, and Time::HiRes.

It's a simple script that sends an ICMP ping every 3 seconds and counts the number of failures.  After 3 consecutive failures, it sends a HTTP GET to the cable modem's reset page.  Total failures and total success rate are recorded in the terminal output.

For terminal output, it produces something like:
Mon Feb 32 12:34:56 1970 - google.com is NOT reachable, fail count 2, total fails 2, success rate 50%

When the connection drops and returns, it saves the time & duration in a log file, like:
Mon Feb 32 12:34:56 1970 - Dropped connection detected, down for ~61.05s
