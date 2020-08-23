open(TEACHERS, "teachers");
while(<TEACHERS>) {
	chomp;
	@subs = split(/\t/, $_);
	$teachers{$subs[0]} = $subs[1];
}


$class = "even";
foreach $prof (
	sort {
		($ime_a, $prezime_a) = split(/ /, $teachers{$a}); 
		($ime_b, $prezime_b) = split(/ /, $teachers{$b}); 
		if ($prezime_a lt $prezime_b) {
			return -1;
		}
		if ($prezime_a gt $prezime_b) {
			return 1;
		}
		return $ime_a cmp $ime_b;
	} keys(%teachers)) {
    ($ime, $prezime) = split(/ /, $teachers{$prof}); 
    print "<tr class='$class'><td><a href='$prof.html'>$prezime, $ime</a></td></tr>\n";
    $class = $class eq "even" ? "odd" : "even";
}
