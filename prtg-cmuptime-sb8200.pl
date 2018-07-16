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


my $content = $ua->get("http://192.168.100.1/cmswinfo.html");
$content->decoded_content =~ m/Up Time<\/strong><\/td>\n    		<td width="40%">(.+)s.00<\/td><\/tr>/;
my $uptime = $1;
#print "<text> Up " . $uptime . "s</text>\n";
#$uptime =~ s/:/ /;
#$uptime .= "s";
$uptime =~ m/(\d+) days (\d+)h:(\d+)m:(\d+)/;
my $updays = $1;
my $uphours = $2;
my $upmins = $3;
my $upsecs = $4;
#print "Up $updays d $uphours h $upmins m $upsecs s\n";
$uptime = $upsecs + ($upmins * 60) + ($uphours * 3600) + ($updays * 86400);
#print "<text> Up " . $uptime . "s</text>\n";

print "<result>\n";
print "<channel>System Uptime</channel>\n";
print "<unit>TimeSeconds</unit>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMinWarning>86400</LimitMinWarning>\n";
print "<LimitWarningMsg>Uptime is less than 1 day</LimitWarningMsg>\n";
print "<value>" . $uptime . "</value>\n";
print "</result>\n";

print "</prtg>";

sub mean {
    return sum(@_)/@_;
}
