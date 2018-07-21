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
#   Forked by John Walshaw 7-15-2018 for SB8200
#   This version is for modem with 29 channels down and 4 up
#   https://regex101.com/r/9QdMIk/2
#   References for thresholds
#   https://pickmymodem.com/signal-levels-docsis-3-03-1-cable-modem/
#   https://forums.xfinity.com/t5/Your-Home-Network/Xfinity-Internet-Connection-Troubleshooting-Tips/m-p/1253575#M94474
#   https://arris.secure.force.com/consumers/articles/General_FAQs/SB8200-Troubleshooting-Internet-Connectivity/?l=en_US&fs=RelatedArticle
use LWP::Simple;
use Math::Round;
use List::Util qw(min max sum);

my @dpw;
my @snr;
my @uncor;
my @upw;
my @dlock;
my @ulock;

#We need this in order to calculate averages
sub mean {
    return sum(@_)/@_;
}

# Set up for a 29-channel modem 4 upstream channels

#We need this in order to use get
my $ua = LWP::UserAgent->new;
my $content = $ua->get("http://192.168.100.1/cmconnectionstatus.html");
$content->decoded_content =~ m/Downstream Bonded Channels.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n.*<tr>\n.*\n.*<td>(.*)<\/td>\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*<td>(.*) dB<\/td>\n.*\n.*<td>(.*)<\/td>\n.*<\/tr>\n<\/table>\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*Upstream Bonded Channels.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*<td>(.+)<\/td>\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*<td>(.+)<\/td>\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*<td>(.+)<\/td>\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n.*\n.*\n.*\n.*<td>(.+)<\/td>\n.*\n.*\n.*\n.*<td>(.*) dBmV<\/td>\n<\/table>/;

# Downstream power level
@dpw[1] = $2;
@dpw[2] = $6;
@dpw[3] = $10;
@dpw[4] = $14;
@dpw[5] = $18;
@dpw[6] = $22;
@dpw[7] = $26;
@dpw[8] = $30;
@dpw[9] = $34;
@dpw[10] = $38;
@dpw[11] = $42;
@dpw[12] = $46;
@dpw[13] = $50;
@dpw[14] = $54;
@dpw[15] = $58;
@dpw[16] = $62;
@dpw[17] = $66;
@dpw[18] = $70;
@dpw[19] = $74;
@dpw[20] = $78;
@dpw[21] = $82;
@dpw[22] = $86;
@dpw[23] = $90;
@dpw[24] = $94;
@dpw[25] = $98;
@dpw[26] = $102;
@dpw[27] = $106;
@dpw[28] = $110;
my $ofdm = $114;

# Downstream lock status
@dlock[1] = $1;
@dlock[2] = $5;
@dlock[3] = $9;
@dlock[4] = $13;
@dlock[5] = $17;
@dlock[6] = $21;
@dlock[7] = $25;
@dlock[8] = $29;
@dlock[9] = $33;
@dlock[10] = $37;
@dlock[11] = $41;
@dlock[12] = $45;
@dlock[13] = $49;
@dlock[14] = $53;
@dlock[15] = $57;
@dlock[16] = $61;
@dlock[17] = $65;
@dlock[18] = $69;
@dlock[19] = $73;
@dlock[20] = $77;
@dlock[21] = $81;
@dlock[22] = $85;
@dlock[23] = $89;
@dlock[24] = $93;
@dlock[25] = $97;
@dlock[26] = $101;
@dlock[27] = $105;
@dlock[28] = $109;
@dlock[29] = $113;
my $countdlock = grep { $_ eq 'Locked' } @dlock;

# Upstream lock status
@ulock[1] = $117;
@ulock[2] = $119;
@ulock[3] = $121;
@ulock[4] = $123;
my $countulock = grep { $_ eq 'Locked' } @ulock;

# Upstream power level
@upw[0] = $118;
@upw[1] = $120;
@upw[2] = $122;
@upw[3] = $124;

# Downstream uncorrectables
@uncor[1] = $4;
@uncor[2] = $8;
@uncor[3] = $12;
@uncor[4] = $16;
@uncor[5] = $20;
@uncor[6] = $24;
@uncor[7] = $28;
@uncor[8] = $32;
@uncor[9] = $36;
@uncor[10] = $40;
@uncor[11] = $44;
@uncor[12] = $48;
@uncor[13] = $52;
@uncor[14] = $56;
@uncor[15] = $60;
@uncor[16] = $64;
@uncor[17] = $68;
@uncor[18] = $72;
@uncor[19] = $76;
@uncor[20] = $80;
@uncor[21] = $84;
@uncor[22] = $88;
@uncor[23] = $92;
@uncor[24] = $96;
@uncor[25] = $100;
@uncor[26] = $104;
@uncor[27] = $108;
@uncor[28] = $112;

# Downstream SNR level
@snr[1] = $3;
@snr[2] = $7;
@snr[3] = $11;
@snr[4] = $15;
@snr[5] = $19;
@snr[6] = $23;
@snr[7] = $27;
@snr[8] = $31;
@snr[9] = $35;
@snr[10] = $39;
@snr[11] = $43;
@snr[12] = $47;
@snr[13] = $51;
@snr[14] = $55;
@snr[15] = $59;
@snr[16] = $63;
@snr[17] = $67;
@snr[18] = $71;
@snr[19] = $75;
@snr[20] = $79;
@snr[21] = $83;
@snr[22] = $87;
@snr[23] = $91;
@snr[24] = $95;
@snr[25] = $99;
@snr[26] = $103;
@snr[27] = $107;
@snr[28] = $111;
my $ofdmsnr = $115;
#Not sure why min returns 0 when applied to @snr
#Sorting seems to be the only way to identify the lowest value
my @sortedsnr = sort { $a <=> $b } @snr;

#Let's test the first match from the regex and verify it isn't a null
#better to show no output if nulls result as otherwise zeros show in PRTG which is incorrect
if (@dlock[1] ne "")
{
	print '<?xml version="1.0" encoding="Windows-1252" ?>' . "\n";
	print "<prtg>\n";
	print "<result>\n";
	
	# Downstream power level

	print "<channel>Downstream Power Avg</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>8</LimitMaxWarning>\n";
	print "<LimitMaxError>15</LimitMaxError>\n";
	print "<LimitMinWarning>-8</LimitMinWarning>\n";
	print "<LimitMinError>-15</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of spec</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of spec, may not work</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, mean(@dpw)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Downstream Power Min</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>8</LimitMaxWarning>\n";
	print "<LimitMaxError>15</LimitMaxError>\n";
	print "<LimitMinWarning>-8</LimitMinWarning>\n";
	print "<LimitMinError>-15</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of spec</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of spec, may not work</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, min(@dpw)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Downstream Power Max</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>8</LimitMaxWarning>\n";
	print "<LimitMaxError>15</LimitMaxError>\n";
	print "<LimitMinWarning>-8</LimitMinWarning>\n";
	print "<LimitMinError>-15</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of spec</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of spec, may not work</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, max(@dpw)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>OFDM Power</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>8</LimitMaxWarning>\n";
	print "<LimitMaxError>15</LimitMaxError>\n";
	print "<LimitMinWarning>-8</LimitMinWarning>\n";
	print "<LimitMinError>-15</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of spec</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of spec, may not work</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, $ofdm) . "</value>\n";
	print "</result>\n";

	# Downstream SNR level

	print "<result>\n";
	print "<channel>Downstream SNR Avg</channel>\n";
	print "<customUnit>dB</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>32.9</LimitMinWarning>\n";
	print "<LimitMinError>29.9</LimitMinError>\n";
	print "<LimitWarningMsg>SNR level below recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>SNR level below recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, mean(@snr)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Downstream SNR Min</channel>\n";
	print "<customUnit>dB</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>32.9</LimitMinWarning>\n";
	print "<LimitMinError>29.9</LimitMinError>\n";
	print "<LimitWarningMsg>SNR level below recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>SNR level below recommended range.</LimitErrorMsg>\n";
	#Not sure why min returns 0 when applied to @snr
	#Sorting seems to be the only way to identify the lowest value
	print "<value>" . nearest(0.1, @sortedsnr[1]) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Downstream SNR Max</channel>\n";
	print "<customUnit>dB</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>32.9</LimitMinWarning>\n";
	print "<LimitMinError>29.9</LimitMinError>\n";
	print "<LimitWarningMsg>SNR level below recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>SNR level below recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, max(@snr)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>OFDM SNR</channel>\n";
	print "<customUnit>dB</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>32.9</LimitMinWarning>\n";
	print "<LimitMinError>29.9</LimitMinError>\n";
	print "<LimitWarningMsg>SNR level below recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>SNR level below recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, $ofdmsnr) . "</value>\n";
	print "</result>\n";

	# Downstream uncorrectables

	print "<result>\n";
	print "<channel>Downstream Uncorrectables</channel>\n";
	print "<unit>#</unit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>100</LimitMaxWarning>\n";
	print "<LimitMaxError>10000</LimitMaxError>\n";
	print "<LimitWarningMsg>Some uncorrectables detected. Reboot modem and continue to monitor.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Many uncorrectables detected. Reboot modem and continue to monitor.</LimitErrorMsg>\n";
	print "<value>" . sum(0, @uncor) . "</value>\n";
	print "</result>\n";

	# Upstream power level

	print "<result>\n";
	print "<channel>Upstream Power Avg</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>50</LimitMaxWarning>\n";
	print "<LimitMaxError>55</LimitMaxError>\n";
	print "<LimitMinWarning>34</LimitMinWarning>\n";
	print "<LimitMinError>30</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, mean(@upw)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Upstream Power Min</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>50</LimitMaxWarning>\n";
	print "<LimitMaxError>55</LimitMaxError>\n";
	print "<LimitMinWarning>34</LimitMinWarning>\n";
	print "<LimitMinError>30</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, min(@upw)) . "</value>\n";
	print "</result>\n";

	print "<result>\n";
	print "<channel>Upstream Power Max</channel>\n";
	print "<customUnit>dBmV</customUnit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMaxWarning>50</LimitMaxWarning>\n";
	print "<LimitMaxError>55</LimitMaxError>\n";
	print "<LimitMinWarning>34</LimitMinWarning>\n";
	print "<LimitMinError>30</LimitMinError>\n";
	print "<LimitWarningMsg>Signal level out of recommended range.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>Signal level out of recommended range.</LimitErrorMsg>\n";
	print "<value>" . nearest(0.1, max(@upw)) . "</value>\n";
	print "</result>\n";

	# Downstream lock status

	print "<result>\n";
	print "<channel>Downstream Locked Channels</channel>\n";
	print "<unit>#</unit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>28</LimitMinWarning>\n";
	print "<LimitMinError>14</LimitMinError>\n";
	print "<LimitWarningMsg>One or more channels not locked.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>More than half channels not locked.</LimitErrorMsg>\n";
	print "<value>" . $countdlock . "</value>\n";
	print "</result>\n";

	# Upstream lock status

	print "<result>\n";
	print "<channel>Upstream Locked Channels</channel>\n";
	print "<unit>#</unit>\n";
	print "<float>1</float>\n";
	print "<LimitMode>1</LimitMode>\n";
	print "<LimitMinWarning>3</LimitMinWarning>\n";
	print "<LimitMinError>2</LimitMinError>\n";
	print "<LimitWarningMsg>One or more channels not locked.</LimitWarningMsg>\n";
	print "<LimitErrorMsg>More than half channels not locked.</LimitErrorMsg>\n";
	print "<value>" . $countulock . "</value>\n";print "</result>\n";
	
	# End of XML output
	
	print "</prtg>\n";

}
