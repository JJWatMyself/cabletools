HOW TO IMPLEMENT (written for SB8200 but applies to others also)
=====================
1. Install Strawberry Perl on the PRTG server
2. Copy perl.exe to PRTG Network Monitor > Custom Sensors > EXEXML
3. Copy desired perl script(s) to PRTG Network Monitor > Custom Sensors > EXEXML
4. Create sensor of type EXE/Script Advanced
5. Set name of sensor, e.g. Cable Modem Stats
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

Supported cable modem models
=====================
* Arris SB6190 (complete sensor support with 16 downstream and 4 upstream channels, no reset on ping failure yet)
* Motorola SB6141 (complete)
* Motorola SB6121 (needs channels adjusted to 4 up and 1 down)
* Motorola SB5100 (needs channels adjusted to 1 up and 1 down)
* Arris SB8200 (advanced monitoring)

Others might work immediately or with some configuration changes, especially using the right number of DOCSIS channels.  Others are completely different and none of the scripts will work.

If you can't get it working with your cable modem, open an issue and I'll add it to the supported list.
