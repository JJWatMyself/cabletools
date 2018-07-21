Internet Drop Checker
=====================

This is a perl script that detects a dropped internet connection before the cable modem can notice something's fucky (if it ever does).  It was created in a fit of incoherent rage and may be contain more bugs than lines of working code.

It requires a Motorola cable modem, or something else that will restart when anyone or anything behind the modem sends an HTTP GET to http://192.168.100.1/reset.htm, Net::Ping, LWP::Simple, Time::HiRes, Sys::Syslog, Win32::Console::ANSI, and Term::ANSIScreen.  It must be run with administrative permissions to use ICMP.

It's a simple script that sends an ICMP ping every 3 seconds and counts the number of failures.  After 5 consecutive failures, it sends a HTTP GET to the cable modem's reset page.  It's intended to be run and left running.

The reset URL seems to be different for the Arris SB6190, so that isn't working yet.

It produces steady terminal output showing success/fail status, dropped packet count, and overall success rate.  Messages about connection status changes will be sent to a syslog server running on 127.0.0.1:514.

A log.txt file will be appended to (or created if it doesn't exist) every time the failure threshold is exceeded and a reset command is sent to the modem.  Downtime, measured in seconds, will be stored in the downtime.txt file and incremented after every interruption.

If you run a DDNS script, after the connection comes back online might be a good time to call it.

HOW TO IMPLEMENT (written for SB8200 but applies to others also)
=====================
1. Install Strawberry Perl on the PRTG server
2. Copy perl.exe to PRTG Network Monitor > Custom Sensors > EXEXML
3. Copy desired perl script(s) to PRTG Network Monitor > Custom Sensors > EXEXML
4. Create sensor of type EXE/Script Advanced
5. Set name of sensor, e.g. Uptime or Cable Modem Stats
6. EXE Script  = perl.exe (this is why you have to copy the perl exe)
7. Parameters = absolute path and filename of script, e.g. "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\prtg-cmstats-sb8200-29down-4up.pl"
8. EXE Results = Write EXE result to disk in case of error
9. Timeout = 45 seconds (I prefer to timeout before the next scan interval, assuming scan interval of 60 seconds. Web server sometimes is slow to respond, so shorter values may result in missing values, e.g. 15 seconds)
10. Consider disabling notifications on the Cable modem device in PRTG as if things are out of spec, the emails will drive you crazy.

PRTG Sensor
=====================
The PRTG sensor runs as a custom/advanced script to return XML formatted signal data from the cable modem.  I've included some default warning and error levels.  
![Preview](https://raw.githubusercontent.com/YandereSkylar/cabletools/master/prtg-preview.png)

Advanced cable modem monitoring for SB8200
![Preview](https://raw.githubusercontent.com/JJWatMyself/cabletools/master/prtg-preview-sb8200-1.png)

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
* Arris SB6190 (complete sensor support with 16 downstream and 4 upstream channels, no reset on ping failure yet)
* Motorola SB6141 (complete)
* Motorola SB6121 (needs channels adjusted to 4 up and 1 down)
* Motorola SB5100 (needs channels adjusted to 1 up and 1 down)
* Arris SB8200 (advanced monitoring)

Others might work immediately or with some configuration changes, especially using the right number of DOCSIS channels.  Others are completely different and none of the scripts will work.

If you can get it working with your cable modem, open an issue and I'll add it to the supported list.
