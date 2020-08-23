open(CODING, "coding");
while(<CODING>) {
	chomp;
	($a, $b) = split(/\t/, $_);
	$codes{$b} = $a;
}

while(<STDIN>) {
		@nums = split(/\s+/, $_);
		foreach $num (@nums) {
			if ($num < 0) {
				print "-".$codes{-$num}."\n";
			} else {
				print $codes{$num}."\n";
			}
		}

#		if ($line =~ /^(-)?(\d+)/) {
#			if ($1 eq "-") {
#				print "-".$codes{$2}."\n";
#			} else {
#				print $codes{$2}."\n";
#			}
#			$line = $';
#		} else {
#			$line = substr($line, 1);
#		}
}
