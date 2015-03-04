#	Dropcheck.pl
#	Homura Akemi / https://github.com/homura/cabletools
#	Checks for a dropped connection that the modem doesn't notice, sends a reset command, and logs the length of time the connection is down
use Net::Ping;
use LWP::Simple;
use Time::HiRes;
use Sys::Syslog;
use Sys::Syslog qw(:extended :macros);

my $host = "google.com";	# Change this if needed
my $failcount = 0;
my $droptime = 0;
my $downtime = 0;
my $offline = 0;
my $endtime = 0;
my $totalfail = 0;
my $total = 0;
my $successrate = 0;
print Time::HiRes::gettimeofday();	# Check for crash when using this
print "\n";

while (1) {
	$datestring = localtime();
	$p = Net::Ping->new("icmp");
	#$p->bind($my_addr); # Specify source interface of pings
	$total = $total + 1;
	print "$datestring - ";
	if ($p->ping($host, 2)) {
		$failcount = 0;
		print "$host is ";
	} else {
		print "$host is NOT ";
		$failcount = $failcount + 1;
		$totalfail = $totalfail + 1;
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
	if ($failcount > 4) {	# Failure threshold of 3 (or 6 seconds)
		$droptime = Time::HiRes::gettimeofday();
		write_log("Failure threshold exceeded, internet connection presumed down, sending reset command to modem");
		print "$datestring - FAILURE THRESHOLD EXCEEDED, RESETTING NOW\n";
		open (logfile, ">>", "log.txt");
		print logfile "$datestring - Dropped connection detected, down for ~";
		close logfile;
		#sleep(3);
		$datestring = localtime();
		$http = get("http://192.168.100.1/reset.htm");
		print "$datestring - Reset command sent, entering downtime measure mode, waiting 60 seconds\n";
		sleep(60); # Let's not hammer it with useless pings immediately; it will always take at least 60s to come back online (my fastest EVER was ~90s)
		$total = $total + 12;
		$totalfail = $totalfail + 12;	# We can assume 12 pings failed during this period.
		$offline = 1;
		while ($offline) {
			$datestring = localtime();
			$honk = Net::Ping->new("icmp");
			$total = $total + 1;
			if ($honk->ping($host, 2)) {
				# Ping successful, appears back online
				$endtime = Time::HiRes::gettimeofday();
				open (logfile, ">>", "log.txt");
				printf logfile ("%.2f", $endtime - $droptime);
				print logfile "s\n";
				close logfile;
				$offline = 0;
				print "$datestring - Connection appears back online after ~";
				printf("%.2f", $endtime - $droptime);
				$downtime = sprintf("%.2f", $endtime - $droptime);
				write_log("Internet connection back online after " . $downtime . " seconds");

				#	Write new total downtime to file
				open (downtimefile, "<", "downtime.txt");
				my @lines = <downtimefile>;
				my $prevdowntime = $lines[0];
				chomp($prevdowntime);
				close downtimefile;
				open (downtimefile, ">", "downtime.txt");
				print downtimefile ($prevdowntime + $downtime);
				close downtimefile;

				print "s\n";
				print "$datestring - Returning to normal mode\n";
			} else {
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