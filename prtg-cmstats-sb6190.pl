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


my $content = $ua->get("http://192.168.100.1/cgi-bin/swinfo");
#<td width="60%"><strong>Up Time</strong></td>
#    		<td width="40%">4 d:  9 h: 56  m</td>
$content->decoded_content =~ m/Up Time<\/strong><\/td>\n    		<td width="40%">(.+)<\/td>/;
my $uptime = $1;
print "<text> Up " . $uptime . "</text>\n";

my $content = $ua->get("http://192.168.100.1/cgi-bin/status");	# Set up for 16 channels

$content->decoded_content =~ m/<tr><td>1<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[0] = $3;
@snr[0] = $4;

$content->decoded_content =~ m/<tr><td>2<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[1] = $3;
@snr[1] = $4;

$content->decoded_content =~ m/<tr><td>3<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[2] = $3;
@snr[2] = $4;

$content->decoded_content =~ m/<tr><td>4<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[3] = $3;
@snr[3] = $4;

$content->decoded_content =~ m/<tr><td>5<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[4] = $3;
@snr[4] = $4;

$content->decoded_content =~ m/<tr><td>6<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[5] = $3;
@snr[5] = $4;

$content->decoded_content =~ m/<tr><td>7<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[6] = $3;
@snr[6] = $4;

$content->decoded_content =~ m/<tr><td>8<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[7] = $3;
@snr[7] = $4;

$content->decoded_content =~ m/<tr><td>9<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[8] = $3;
@snr[8] = $4;

$content->decoded_content =~ m/<tr><td>10<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[9] = $3;
@snr[9] = $4;

$content->decoded_content =~ m/<tr><td>11<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[10] = $3;
@snr[10] = $4;

$content->decoded_content =~ m/<tr><td>12<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[11] = $3;
@snr[11] = $4;

$content->decoded_content =~ m/<tr><td>13<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[12] = $3;
@snr[12] = $4;

$content->decoded_content =~ m/<tr><td>14<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[13] = $3;
@snr[13] = $4;

$content->decoded_content =~ m/<tr><td>15<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[14] = $3;
@snr[14] = $4;

$content->decoded_content =~ m/<tr><td>16<\/td><td> Locked <\/td><td>256QAM<\/td><td>(\d+)<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td><td>([\d\.]+) dB<\/td><td>(\d+)<\/td><td>(\d+)<\/td><\/tr>/;
@dpw[15] = $3;
@snr[15] = $4;


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

print "<result>\n";
print "<channel>Downstream SNR</channel>\n";
print "<customUnit>dB</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>33</LimitMinWarning>\n";
print "<LimitMinError>30</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.01, mean(@snr)) . "</value>\n";
print "</result>\n";

#	Set up for 4 upstream channels
$content->decoded_content =~ m/<tr><td>1<\/td><td> Locked <\/td><td>ATDMA<\/td><td>(\d+)<\/td><td>5120 kSym\/s<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td>/;
@upw[0] = $3;
$content->decoded_content =~ m/<tr><td>2<\/td><td> Locked <\/td><td>ATDMA<\/td><td>(\d+)<\/td><td>5120 kSym\/s<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td>/;
@upw[1] = $3;
$content->decoded_content =~ m/<tr><td>3<\/td><td> Locked <\/td><td>ATDMA<\/td><td>(\d+)<\/td><td>5120 kSym\/s<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td>/;
@upw[2] = $3;
$content->decoded_content =~ m/<tr><td>4<\/td><td> Locked <\/td><td>ATDMA<\/td><td>(\d+)<\/td><td>5120 kSym\/s<\/td><td>([\d\.]+) MHz<\/td><td>([\d\.]+) dBmV<\/td>/;
@upw[3] = $3;

print "<result>\n";
print "<channel>Upstream Power Level</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>50</LimitMaxWarning>\n";
print "<LimitMaxError>55</LimitMaxError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.01, mean(@upw)) . "</value>\n";
print "</result>\n";

print "</prtg>";

sub mean {
    return sum(@_)/@_;
}