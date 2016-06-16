#	Checks signal levels, logs anything out of the ordinary
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
use Sys::Syslog;
use Sys::Syslog qw(:extended :macros);

#	These numbers were given to me by a Cox technician
my $warn_min_snr = "33";
my $crit_min_snr = "30";
my $warn_min_dpw = "-4";
my $warn_max_dpw = "8";
my $crit_min_dpw = "-15";
my $crit_max_dpw = "15";
my $warn_max_upw = "50";
my $crit_max_upw = "55";
my @dpw;
my @snr;
my @upw;


my $ua = LWP::UserAgent->new;
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
print "Downstream power levels: ";
print $dpw[0] . "," . $dpw[1] . "," . $dpw[2]  . "," . $dpw[3]  . "," . $dpw[4] . "," . $dpw[5]  . "," . $dpw[6]  . "," . $dpw[7] . "; avg " . nearest(0.1, mean(@dpw)) . ", min " . min(@dpw) . ", max " . max(@dpw) . "\n";
if (min(@dpw) < $crit_min_dpw) {
	write_log('Downstream power level (' . min(@dpw) . ') below critical minimum (' . $crit_min_dpw . ')');
} elsif (min(@dpw) < $warn_min_dpw) {
	write_log('Downstream power level (' . min(@dpw) . ') below warning minimum (' . $warn_min_dpw . ')');
}
if (max(@dpw) > $crit_max_dpw) {
	write_log('Downstream power level (' . max(@dpw) . ') above critical maximum (' . $crit_max_dpw . ')');
} elsif (max(@dpw) > $warn_max_dpw) {
	write_log('Downstream power level (' . max(@dpw) . ') above warning minimum (' . $warn_max_dpw . ')');
}

$content->decoded_content =~ m/<TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB\&nbsp;<\/TD><TD>(.+) dB&nbsp;<\/TD><TD>(.+) dB&nbsp;<\/TD><TD>(.+) dB/;
@snr[0] = $1;
@snr[1] = $2;
@snr[2] = $3;
@snr[3] = $4;
@snr[4] = $5;
@snr[5] = $6;
@snr[6] = $7;
@snr[7] = $8;
print "Downstream SNRs: ";
print $snr[0] . "," . $snr[1] . "," . $snr[2]  . "," . $snr[3]  . "," . $snr[4] . "," . $snr[5]  . "," . $snr[6]  . "," . $snr[7] . "; avg " . nearest(0.1, mean(@snr)) . ", min " . min(@snr) . ", max " . max(@snr) . "\n";
if (min(@snr) < $crit_min_snr) {
	write_log('Downstream SNR (' . min(@snr) . ') below critical minimum (' . $crit_min_snr . ')');
} elsif (min(@snr) < $warn_min_snr) {
	write_log('Downstream SNR (' . min(@snr) . ') below warning minimum (' . $warn_min_snr . ')');
}

#	Set up for 4 upstream channels
$content->decoded_content =~ m/<TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><TD>(.+) dBmV\&nbsp;<\/TD><\/TR>/;
@upw[0] = $1;
@upw[1] = $2;
@upw[2] = $3;
@upw[3] = $4;
print "Upstream power levels: ";
print $upw[0] . "," . $upw[1] . "," . $upw[2]  . "," . $upw[3]  . "; avg " . nearest(0.1, mean(@upw)) . ", min " . min(@upw) . ", max " . max(@upw) . "\n";
if (min(@upw) < $crit_min_upw) {
	write_log('Upstream power level (' . min(@upw) . ') below critical minimum (' . $crit_min_upw . ')');
} elsif (min(@upw) < $warn_min_upw) {
	write_log('Upstream power level (' . min(@upw) . ') below warning minimum (' . $warn_min_upw . ')');
}
if (max(@upw) > $crit_max_upw) {
	write_log('Upstream power level (' . max(@upw) . ') above critical maximum (' . $crit_max_upw . ')');
} elsif (max(@upw) > $warn_max_upw) {
	write_log('Upstream power level (' . max(@upw) . ') above warning minimum (' . $warn_max_upw . ')');
}

sub write_log {
	my $output = shift;
	setlogsock("udp", "127.0.0.1");
	openlog($program, 'ndelay', 'LOG_NETINFO');
	syslog('LOG_WARNING', $output);
}

sub mean {
    return sum(@_)/@_;
}