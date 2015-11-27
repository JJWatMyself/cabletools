Internet Drop Checker
=====================

This is a perl script that detects a dropped internet connection before the cable modem can notice something's fucky (if it ever does).  It was created in a fit of incoherent rage and may be contain more bugs than lines of working code.

It requires a Motorola cable modem, or something else that will restart when anyone or anything behind the modem sends an HTTP GET to http://192.168.100.1/reset.htm, Net::Ping, LWP::Simple, Time::HiRes, Sys::Syslog, Win32::Console::ANSI, and Term::ANSIScreen.  It must be run with administrative permissions to use ICMP.

It's a simple script that sends an ICMP ping every 3 seconds and counts the number of failures.  After 5 consecutive failures, it sends a HTTP GET to the cable modem's reset page.  It's intended to be run and left running.

It produces steady terminal output showing success/fail status, dropped packet count, and overall success rate.  Messages about connection status changes will be sent to a syslog server running on 127.0.0.1:514.

A log.txt file will be appended to (or created if it doesn't exist) every time the failure threshold is exceeded and a reset command is sent to the modem.  Downtime, measured in seconds, will be stored in the downtime.txt file and incremented after every interruption.

If you run a DDNS script, after the connection comes back online would be a good time to call it.

PRTG Sensor
=====================
The PRTG sensor runs as a custom/advanced script to return XML formatted signal data from the cable modem.  I've included some default warning and error levels.  
![Preview](https://raw.githubusercontent.com/homura/cabletools/master/prtg-preview.png)


Cable signal checker
=====================

This script fetches the current cable signals from the modem, checks them against recommended values, and sends a syslog message to 127.0.0.1:514 if they're out of range.  It's intended to be run with a scheduled task or cron job.

Terminal output is a list of the signal levels, along with their minimum, average, and maximum.  The script is configured for a modem with 8 DOCSIS channels down and 4 channels up, but that can be changed to any number.


Availability
=====================
Shows the percentage of time the internet connection was available, based on a starting timestamp (that must be manually configured) and downtime.txt.  Requires the Math::Round package.


Rainmeter skin
=====================
Displays the signal level from the first downstream channel.  I no longer use or maintain this.


Supported cable modem models
=====================
* Motorola SB6141 (complete)
* Motorola SB6121 (needs channels adjusted to 4 up and 1 down)
* Motorola SB5100 (needs channels adjusted to 1 up and 1 down)

Others might work immediately or with some configuration changes, especially using the right number of DOCSIS channels.  Others are completely different and none of the scripts will work.

If you can get it working with your cable modem, open an issue and I'll add it to the supported list.
