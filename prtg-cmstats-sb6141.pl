#	Returns XML formatted data from a motorola cable modem for PRTG
#	Skylar Gasai / https://github.com/YandereSkylar/cabletools
#
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    
use LWP::Simple;
use Math::Round;
use List::Util qw(sum);
use List::Util qw( min max );
use List::MoreUtils qw( minmax );

my @dpw;
my @snr;
my @upw;

print '<?xml version="1.0" encoding="Windows-1252" ?>' . "\n";
print "<prtg>\n";

my $ua = LWP::UserAgent->new;


my $content = $ua->get("http://192.168.100.1/indexData.htm");
$content->decoded_content =~ m/System Up Time<\/TD>\n    <TD>(.+)s<\/TD><\/TR>/;
my $uptime = $1;
print "<text> Up " . $uptime . "s</text>\n";
#$uptime =~ s/:/ /;
#$uptime .= "s";
# $uptime =~ m/(\d+) days (\d+)h:(\d+)m:(\d+)/;
# my $updays = $1;
# my $uphours = $2;
# my $upmins = $3;
# my $upsecs = $4;
# #print "Up $updays d $uphours h $upmins m $upsecs s";
# $uptime = $upsecs + ($upmins * 60) + ($uphours * 3600) + ($updays * 86400);

# print "<result>\n";
# print "<channel>Cable Modem Uptime</channel>\n";
# print "<unit>TimeHours</unit>\n";
# print "<value>" . $uptime . "</value>\n";
# print "</result>\n";

my $content = $ua->get("http://192.168.100.1/cmSignalData.htm");	# Set up for an 8-channel modem

#	Downstream power level
$content->decoded_content =~ m/<TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV\n\&nbsp;<\/TD><TD>(.+) dBmV/;
@dpw[0] = $1;
@dpw[1] = $2;
@dpw[2] = $3;
@dpw[3] = $4;
@dpw[4] = $5;
@dpw[5] = $6;
@dpw[6] = $7;
@dpw[7] = $8;

print "<result>\n";
print "<channel>Downstream Power Level</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>8</LimitMaxWarning>\n";
print "<LimitMaxError>15</LimitMaxError>\n";
print "<LimitMinWarning>-4</LimitMinWarning>\n";
print "<LimitMinError>-15</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, mean(@dpw)) . "</value>\n";
print "</result>\n";


$content->decoded_content =~ m/<TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB&nbsp;<\/TD><TD>(.+) dB&nbsp;<\/TD><TD>(.+) dB/;
@snr[0] = $1;
@snr[1] = $2;
@snr[2] = $3;
@snr[3] = $4;
@snr[4] = $5;
@snr[5] = $6;
@snr[6] = $7;
@snr[7] = $8;

print "<result>\n";
print "<channel>Downstream SNR</channel>\n";
print "<customUnit>dB</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>33</LimitMinWarning>\n";
print "<LimitMinError>30</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, mean(@snr)) . "</value>\n";
print "</result>\n";

#	Set up for 4 upstream channels
$content->decoded_content =~ m/<TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><\/TR>/;
@upw[0] = $1;
@upw[1] = $2;
@upw[2] = $3;
@upw[3] = $4;

print "<result>\n";
print "<channel>Upstream Power Level</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>50</LimitMaxWarning>\n";
print "<LimitMaxError>55</LimitMaxError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, mean(@upw)) . "</value>\n";
print "</result>\n";

print "</prtg>";

sub mean {
    return sum(@_)/@_;
}