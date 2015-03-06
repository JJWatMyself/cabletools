#	Calculates availability using a starting timestamp and text file of downtime in seconds
#	Homura Akemi / https://github.com/homura/cabletools
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