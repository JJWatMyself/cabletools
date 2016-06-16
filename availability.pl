#	Calculates availability using a starting timestamp and text file of downtime in seconds
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

use Math::Round;

#	Date and time that monitoring started, in UNIX timestamp format
my $startdate = 1400000000;

my $now = time();
my $passed = $now - $startdate;
open (dtfile, "<", "downtime.txt");
my @lines = <dtfile>;
my $downtime = $lines[0];
chomp($downtime);
close dtfile;
my $uptime = $passed - $downtime;
my $ava = $uptime / $passed;
my $ava = ($ava * 100);
print nearest(.000001, $ava);
print "%";