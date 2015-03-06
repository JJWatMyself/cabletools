Internet Drop Checker
=====================

This is a perl script that detects a dropped internet connection before the cable modem can notice something's fucky (if it ever does).  It was created in a fit of incoherent rage and may be contain more bugs than lines of working code.

It requires a Motorola cable modem, or something else that will restart when anyone or anything behind the modem sends an HTTP GET to http://192.168.100.1/reset.htm, Net::Ping, LWP::Simple, Time::HiRes, and Sys::Syslog.

It's a simple script that sends an ICMP ping every 3 seconds and counts the number of failures.  After 5 consecutive failures, it sends a HTTP GET to the cable modem's reset page.  It's intended to be run and left running.

It produces steady terminal output showing success/fail status, dropped packet count, and overall success rate.  Messages about connection status changes will be sent to a syslog server running on 127.0.0.1:514.

A log.txt file will be appended to (or created if it doesn't exist) every time the failure threshold is exceeded and a reset command is sent to the modem.  Downtime, measured in seconds, will be stored in the downtime.txt file and incremented after every interruption.

If you run a DDNS script, after the connection comes back online would be a good time to call it.


Cable signal checker
=====================

This script fetches the current cable signals from the modem, checks them against recommended values, and sends a syslog message to 127.0.0.1:514 if they're out of range.  It's intended to be run with a scheduled task or cron job.

Terminal output is a list of the signal levels, along with their minimum, average, and maximum.  The script is configured for a modem with 8 DOCSIS channels down and 4 channels up, but that can be changed to any number.


Availability
=====================
Shows the percentage of time the internet connection was available, based on a starting timestamp (that must be manually configured) and downtime.txt.  Requires the Math::Round package.


Rainmeter skin
=====================
Displays the signal level from the first downstream channel.
