#!/usr/bin/perl
$cnt = 0;
while($line = <STDIN>) {
	if ($line =~ /^([^_]*)_([^_]*)_([^_]*)_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
		$key = $4."_".$5;
		$3 =~ /([^.]+)([.]([^.]+))?([.][0-9]+)/;
		$entry = "$1$4";
		if ($matrix{$key}) {
			if ($entry ne $matrix{$key}) {
				$matrix{$key} = "error";
			}
		} else {
			$matrix{$key} = $entry;
			$cnt++;
		}
	}
	if ($line =~ /^[^_-]+_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
		$key = $1."_".$2;
		$has{$key} = "+";
	}
	if ($line =~ /^-[^_]+_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
		$key = $1."_".$2;
		$has{$key} = "-";
	}

}

@days = ("pon", "uto", "sre", "cet", "pet");
for ($i = 1; $i <= 7; $i++) {
if ($i >= 10) {
print "$i:    ";
} else {
print "$i :    ";
}
	foreach $day (@days) {
		$entry = $matrix{$day."_".$i};
		if ($entry) {
			printf("%-20s", $entry);
		} else {
			if ($has{$day."_".$i}) {
				print $has{$day."_".$i};
			} else {
				print ".";
			}
			print "                   ";
		}
	}
	print "\n";
}
print "Total: $cnt\n";
