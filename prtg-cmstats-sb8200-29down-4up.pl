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
my @uncor;
my @upw;

print '<?xml version="1.0" encoding="Windows-1252" ?>' . "\n";
print "<prtg>\n";

my $ua = LWP::UserAgent->new;

# Set up for a 29-channel modem 4 upstream channels

my $content = $ua->get("http://192.168.100.1/cmconnectionstatus.html");
$content->decoded_content =~ m/Downstream Bonded Channels.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*Hz<\/td>\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*Upstream Bonded Channels.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n<\/table>/;

#my $test1 = $1;
#my $test2 = $2;
#my $ofdm = $29;
#print "<text> Test " . $test1 . "</text>\n";
#print "<text> Test " . $test2 . "</text>\n";
#print "<text> OFDM " . $ofdm . "</text>\n";

# Downstream power level
@dpw[1] = $1;
@dpw[2] = $4;
@dpw[3] = $7;
@dpw[4] = $10;
@dpw[5] = $13;
@dpw[6] = $16;
@dpw[7] = $19;
@dpw[8] = $22;
@dpw[9] = $25;
@dpw[10] = $28;
@dpw[11] = $31;
@dpw[12] = $34;
@dpw[13] = $37;
@dpw[14] = $40;
@dpw[15] = $43;
@dpw[16] = $46;
@dpw[17] = $49;
@dpw[18] = $52;
@dpw[19] = $55;
@dpw[20] = $58;
@dpw[21] = $61;
@dpw[22] = $64;
@dpw[23] = $67;
@dpw[24] = $70;
@dpw[25] = $73;
@dpw[26] = $76;
@dpw[27] = $79;
@dpw[28] = $82;
my $ofdm = $85;
print "<result>\n";
print "<channel>Downstream Power Level Average</channel>\n";
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
print "<channel>Downstream Power Level Minimum</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>8</LimitMaxWarning>\n";
print "<LimitMaxError>15</LimitMaxError>\n";
print "<LimitMinWarning>-4</LimitMinWarning>\n";
print "<LimitMinError>-15</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, min(@dpw)) . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Downstream Power Level Maximum</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>8</LimitMaxWarning>\n";
print "<LimitMaxError>15</LimitMaxError>\n";
print "<LimitMinWarning>-4</LimitMinWarning>\n";
print "<LimitMinError>-15</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, max(@dpw)) . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Download OFDM Power Level</channel>\n";
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

# Downstream SNR level
@snr[1] = $2;
@snr[2] = $5;
@snr[3] = $8;
@snr[4] = $11;
@snr[5] = $14;
@snr[6] = $17;
@snr[7] = $20;
@snr[8] = $23;
@snr[9] = $26;
@snr[10] = $29;
@snr[11] = $32;
@snr[12] = $35;
@snr[13] = $38;
@snr[14] = $41;
@snr[15] = $44;
@snr[16] = $47;
@snr[17] = $50;
@snr[18] = $53;
@snr[19] = $56;
@snr[20] = $59;
@snr[21] = $62;
@snr[22] = $65;
@snr[23] = $68;
@snr[24] = $71;
@snr[25] = $74;
@snr[26] = $77;
@snr[27] = $80;
@snr[28] = $83;
my $ofdmsnr = $86;

print "<result>\n";
print "<channel>Downstream SNR Average</channel>\n";
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
print "<channel>Downstream SNR Minimum</channel>\n";
print "<customUnit>dB</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>33</LimitMinWarning>\n";
print "<LimitMinError>30</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, min(@snr)) . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Downstream SNR Maximum</channel>\n";
print "<customUnit>dB</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>33</LimitMinWarning>\n";
print "<LimitMinError>30</LimitMinError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, max(@snr)) . "</value>\n";
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

# Downstream uncorrectables
@uncor[1] = $3;
@uncor[2] = $6;
@uncor[3] = $9;
@uncor[4] = $12;
@uncor[5] = $15;
@uncor[6] = $18;
@uncor[7] = $21;
@uncor[8] = $24;
@uncor[9] = $27;
@uncor[10] = $30;
@uncor[11] = $33;
@uncor[12] = $36;
@uncor[13] = $39;
@uncor[14] = $42;
@uncor[15] = $45;
@uncor[16] = $48;
@uncor[17] = $51;
@uncor[18] = $54;
@uncor[19] = $57;
@uncor[20] = $60;
@uncor[21] = $63;
@uncor[22] = $66;
@uncor[23] = $69;
@uncor[24] = $72;
@uncor[25] = $75;
@uncor[26] = $78;
@uncor[27] = $81;
@uncor[28] = $84;
@uncor[28] = $87;
print "<result>\n";
print "<channel>Downstream Uncorrectables Cummulative</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>100</LimitMaxWarning>\n";
print "<LimitMaxError>1000</LimitMaxError>\n";
#print "<LimitMinWarning>-4</LimitMinWarning>\n";
#print "<LimitMinError>-15</LimitMinError>\n";
print "<LimitWarningMsg>Uncorrectables detected. Reboot modem and continue to monitor.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Uncorrectables detected. Reboot modem and continue to monitor.</LimitErrorMsg>\n";
print "<value>" . sum(0, @uncor) . "</value>\n";
print "</result>\n";

# Upstream power level
@upw[0] = $88;
@upw[1] = $89;
@upw[2] = $90;
@upw[3] = $91;

print "<result>\n";
print "<channel>Upstream Power Level Average</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>50</LimitMaxWarning>\n";
print "<LimitMaxError>55</LimitMaxError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, mean(@upw)) . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Upstream Power Level Minimum</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>50</LimitMaxWarning>\n";
print "<LimitMaxError>55</LimitMaxError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, min(@upw)) . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Upstream Power Level Maximum</channel>\n";
print "<customUnit>dBmV</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>50</LimitMaxWarning>\n";
print "<LimitMaxError>55</LimitMaxError>\n";
print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
print "<value>" . nearest(0.1, max(@upw)) . "</value>\n";
print "</result>\n";

print "</prtg>";

sub mean {
    return sum(@_)/@_;
}
