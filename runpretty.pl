$out = $#ARGV >= 0 ? $ARGV[0] : "out";

open(OUT, $out);
while(<OUT>) {
    if (/^([^_]*)_([^_]*)_([^_]*)_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
	chomp;
	@parts = split(/_/, $_);
	$teachers{$parts[0]} = 1;
	$groups{$parts[1]} = 1;
	}
}

foreach $g (sort(keys(%groups))) {
	print "-------------------------------------------------------------------------------\n";
	print "$g\n";
	print "-------------------------------------------------------------------------------\n";
	system("grep $g $out | perl pretty_all.pl");
}


foreach $t (sort(keys(%teachers))) {
	print "------------------------------------------------------------------------------\n";
	print "$t\n";
	print "------------------------------------------------------------------------------\n";
	system("egrep \"^$t"."_"."\" $out | perl pretty_all.pl");
}

