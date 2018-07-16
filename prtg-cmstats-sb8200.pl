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
#   Updated by John Walshaw 7-15-2018 for SB8200 in DOCSIC 3.1 mode
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

# Set up for a 29-channel modem
my $content = $ua->get("http://192.168.100.1/cmconnectionstatus.html");

#	Downstream power level
$content->decoded_content =~ m/Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n/;

#my $test1 = $1;
#my $test2 = $2;
#my $ofdm = $29;
#print "<text> Test " . $test1 . "</text>\n";
#print "<text> Test " . $test2 . "</text>\n";
#print "<text> OFDM " . $ofdm . "</text>\n";

@dpw[25] = $1;
@dpw[1] = $2;
@dpw[2] = $3;
@dpw[3] = $4;
@dpw[4] = $5;
@dpw[5] = $6;
@dpw[6] = $7;
@dpw[7] = $8;
@dpw[8] = $9;
@dpw[9] = $10;
@dpw[10] = $11;
@dpw[11] = $12;
@dpw[12] = $13;
@dpw[13] = $14;
@dpw[14] = $15;
@dpw[15] = $16;
@dpw[16] = $17;
@dpw[17] = $18;
@dpw[18] = $19;
@dpw[19] = $20;
@dpw[20] = $21;
@dpw[21] = $22;
@dpw[22] = $23;
@dpw[23] = $24;
@dpw[24] = $25;
@dpw[26] = $26;
@dpw[27] = $27;
@dpw[28] = $28;
my $ofdm = $29;
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
print "<channel>OFDM Power Level</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>8</LimitMaxWarning>\n";
print "<LimitMaxError>15</LimitMaxError>\n";
print "<LimitMinWarning>-4</LimitMinWarning>\n";
print "<LimitMinError>-15</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, $ofdm) . "</value>\n";
print "</result>\n";


$content->decoded_content =~ m/dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+dBmV<\/td>\n.+<td>(.+) dB<\/td>\n/;
#my $test1 = $1;
#my $test2 = $2;
#my $ofdmsnr = $29;
#print "<text> Test " . $test1 . "</text>\n";
#print "<text> Test " . $test2 . "</text>\n";
#print "<text> OFDM " . $ofdmsnr . "</text>\n";
@snr[25] = $1;
@snr[1] = $2;
@snr[2] = $3;
@snr[3] = $4;
@snr[4] = $5;
@snr[5] = $6;
@snr[6] = $7;
@snr[7] = $8;
@snr[8] = $9;
@snr[9] = $10;
@snr[10] = $11;
@snr[11] = $12;
@snr[12] = $13;
@snr[13] = $14;
@snr[14] = $15;
@snr[15] = $16;
@snr[16] = $17;
@snr[17] = $18;
@snr[18] = $19;
@snr[19] = $20;
@snr[20] = $21;
@snr[21] = $22;
@snr[22] = $23;
@snr[23] = $24;
@snr[24] = $25;
@snr[26] = $26;
@snr[27] = $27;
@snr[28] = $28;
my $ofdmsnr = $29;

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

print "<result>\n";
print "<channel>Downstream OFDM SNR</channel>\n";
print "<customUnit>dB</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>33</LimitMinWarning>\n";
print "<LimitMinError>30</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, $ofdmsnr) . "</value>\n";
print "</result>\n";

#	Set up for 4 upstream channels
$content->decoded_content =~ m/Upstream Bonded Channels<\/strong><\/th><\/tr>\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n.+\n.+\n.+\n.+\n.+\n.+\n.+Hz<\/td>\n.+<td>(.+) dBmV<\/td>\n/;
#my $test1 = $1;
#my $test2 = $2;
#print "<text> Test " . $test1 . "</text>\n";
#print "<text> Test " . $test2 . "</text>\n";
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
