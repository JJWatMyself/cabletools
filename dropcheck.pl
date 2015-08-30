#	Dropcheck.pl
# 	version 0.2.1
#	Skylar Akemi / https://github.com/homura/cabletools
#	Checks for a dropped connection that the modem doesn't notice, sends a reset command, and logs the length of time the connection is down
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
use Net::Ping;
use LWP::Simple;
use Time::HiRes;
use Sys::Syslog;
use Sys::Syslog qw(:extended :macros);
use Win32::Console::ANSI;
use Term::ANSIScreen qw/:color /;

my @multihost = ("bing.com", "google.com", "8.8.8.8", "4.2.2.2");	 # Now cycles through multiple hosts
my $failcount = 0;
my $droptime = 0;
my $downtime = 0;
my $offline = 0;
my $endtime = 0;
my $totalfail = 0;
my $total = 0;
my $successrate = 0;
our $maincounter = 0;

print colored("dropcheck.pl  Copyright (C) 2015  Skylar Akemi\n", "bold red");
print "This program comes with ABSOLUTELY NO WARRANTY.  This is free software, and you are welcome to redistribute it under certain conditions.\n";

write_log("Initialized internet drop checker");

while (1) {
	$datestring = localtime();
	$p = Net::Ping->new("icmp");
	#$p->bind($my_addr); # Specify source interface of pings
	$total = $total + 1;
	print "$datestring - ";
	if ($p->ping($multihost[$maincounter], 2)) {
		$failcount = 0;
		print colored("$multihost[$maincounter] is ", "bold green");
		maincounter();
	} else {
		print colored("$multihost[$maincounter] is NOT ", "bold red");
		$failcount = $failcount + 1;
		$totalfail = $totalfail + 1;
		write_log("No ping response from " . $multihost[$maincounter]);
		maincounter();
	}
	if ($totalfail == 0) {
		$successrate = 1;
	} else {
		$successrate = ($total - $totalfail) / $total;
	}
	print "reachable, ";
	print "fail count $failcount, total fails $totalfail";
	my $outsuccessrate = $successrate * 100;
	print ", success rate $outsuccessrate%";
	print "\n";
	if ($failcount > 5) {	# Failure threshold of 6 (or 18 seconds)
		$droptime = Time::HiRes::gettimeofday();
		write_log("Failure threshold exceeded, internet connection presumed down, sending reset command to modem");
		print colored("$datestring - FAILURE THRESHOLD EXCEEDED, RESETTING NOW\n", "bold red");
		open (logfile, ">>", "log.txt");
		print logfile "$datestring - Dropped connection detected, down for ~";
		close logfile;
		#sleep(3);
		$datestring = localtime();
		my $ua = LWP::UserAgent->new;
		$ua->timeout(8);
		$ua->env_proxy;
		$ua->max_redirect(0);
		#$ua->default_header('Accept-Encoding' => scalar HTTP::Message::decodable());
		$ua->agent('Mozilla/5.0+(Windows+NT+6.2;+WOW64;+rv:28.0)+Gecko/20100101+Firefox/28.0');
		#$ua->referer("http://192.168.0.1/cmConfig.htm");
		my $maxsize = (1024 * 1024 * 4);
		$ua->max_size($maxsize);
		my $response = $ua->get("http://192.168.100.1/reset.htm");
		if ($response->is_success) {
			print "$datestring - Reset command sent, entering downtime measure mode, waiting 15 seconds\n";
			sleep(15); # Let's not hammer it with useless pings immediately; it takes a while to come back online
			$total = $total + 5;
			$totalfail = $totalfail + 5;	# We can assume 5 pings failed during this period.
			$offline = 1;
		} else {
			print colored("$datestring - CRITICAL: RESET COMMAND FAILED\n", "bold red");
			write_log("Failed to send reset command to the modem");
			my $response2 = $ua->get("http://192.168.100.1/reset.htm");	# Try again.
			if ($response2->is_success) {
				$datestring = localtime();
				print "$datestring - Reset command sent, entering downtime measure mode, waiting 15 seconds\n";
			}
			sleep(15);
			$total = $total + 5;
			$totalfail = $totalfail + 5;
			$offline = 1;
		}
		while ($offline) {
			$datestring = localtime();
			$honk = Net::Ping->new("icmp");
			$total = $total + 1;
			if ($honk->ping($multihost[$maincounter], 2)) {
				maincounter();
				# Ping successful, appears back online
				$endtime = Time::HiRes::gettimeofday();
				open (logfile, ">>", "log.txt");
				printf logfile ("%.2f", $endtime - $droptime);
				print logfile "s\n";
				close logfile;
				$offline = 0;
				print colored("$datestring - Connection appears back online after ~", "bold green");
				printf("%.2f", $endtime - $droptime);
				$downtime = sprintf("%.2f", $endtime - $droptime);
				write_log("Internet connection back online after " . $downtime . " seconds");

				#	Write new total downtime to file, used for calculating availability
				open (dtimefile, "<", "downtime.txt");
				my @lines = <dtimefile>;
				my $prevdowntime = $lines[0];
				chomp($prevdowntime);
				close dtimefile;
				open (dtimefile, ">", "downtime.txt");
				print dtimefile ($prevdowntime + $downtime);
				close dtimefile;

				print "s\n";
				print "$datestring - Returning to normal mode\n";
			} else {
				$maincounter++;
				print "$datestring - Connection still down, waiting\n";
				$totalfail = $totalfail + 1;
			}
			sleep(3);
			$honk->close();
		}
	}
	sleep(3);	# can be adjusted to a longer/shorter ping interval, but 3s seems to work good enough
	$p->close();
}

sub write_log {
	my $output = shift;
	setlogsock("udp", "127.0.0.1");
	openlog($program, 'ndelay', 'LOG_NETINFO');
	syslog('LOG_WARNING', $output);
}

sub maincounter {
	if ($maincounter >= (scalar(@multihost) -1)) {
		$maincounter = 0;
	} else {
		$maincounter++;
	}
}