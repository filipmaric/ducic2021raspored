open(SUBJECTS, "subjects");
while(<SUBJECTS>) {
	chomp;
	@subs = split(/\t/, $_);
	$subjects{$subs[0]} = $subs[1];
}

open(TEACHERS, "teachers");
while(<TEACHERS>) {
	chomp;
	@subs = split(/\t/, $_);
	$teachers{$subs[0]} = $subs[1];
}

open(RAZREDNI, "razredni");
while(<RAZREDNI>) {
	chomp;
	@subs = split(/\t/, $_);
	$razredni{$subs[0]} = $subs[1];
}

while($line = <STDIN>) {
	if ($line =~ /^([^_]*)_([^_]*)_([^_]+)[.](p|v)[.][0-9]+_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
		$teacher = $1;
		$group = $2;
		$subject = $3;
		$day = $5;
		$hour = $6;

		$key = $teacher."_".$day."_".$hour;
		$profs{$teacher} = 1;
		
		if (!$matrix{$key}) {
                    $matrix{$key} = $group;
		} else {
                    $indeks = substr($group, 1, 1);
                    $matrix{$key} = "$matrix{$key}$indeks";
		}
		
		if (!$teaches{$teacher}) {
			$teaches{$teacher} = [$subject];
		} elsif (!grep(/$subject/, @{$teaches{$teacher}})) {
			push(@{$teaches{$teacher}}, $subject);
		}
	}
}


print "
<html>
<title>Raspored časova</title>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<head>
<style type='text/css'>
body, td, th {font-family : Arial; font-size : 10pt}
td, th {background : white}
th.dan {background : #FDB200}
table {background : black}
td.razred5 {background : #62B7FF}
td.razred6 {background : #80CC80;}
td.razred7 {background : #FB7CC7;}
td.razred8 {background : #FFDD40;}
a { text-decoration : none; color: black}
a:hover {text-decoration : underline;}
</style>
</head>
<body>
<div style='margin-left : auto'>

<table class='timetable' cellspacing='1px' align='center' border='0'>
<tr>
<td><img width='10' height='0'></td>
<td><img width='200' height='0'></td>
<td><img width='300' height='0'></td>
<td>&nbsp;</td>
<td>&nbsp;</td><th class='dan' colspan='7'>Ponedeljak</th>
<td>&nbsp;</td><th class='dan' colspan='7'>Utorak</th>
<td>&nbsp;</td><th class='dan' colspan='7'>Sreda</th>
<td>&nbsp;</td><th class='dan' colspan='7'>Četvrtak</th>
<td>&nbsp;</td><th class='dan' colspan='7'>Petak</th>
</tr>
";

@days = ("pon", "uto", "sre", "cet", "pet");

print "<tr><td></td><td></td><td></td><td></td>";
foreach $day (@days) {
	print "<td></td>";
	for ($i = 1; $i <= 7; $i++) {
            print "<td><img width='30' height='0'/><br><i>$i.</i></td>";
	}
}
print "</td>\n";

$rupa = 0;
$prof_num = 1;
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
	} keys(%profs)) {
	print "<tr>\n";
	print "<th>$prof_num</th>\n";
	($ime, $prezime) = split(/ /, $teachers{$prof}); 
	print "<th><a href='$prof.html'>$prezime, $ime</a></th>\n";
	print "<td>";
	
	my %seen;
	print join(", ", grep !$seen{$_}++, (map { $subjects{$_} } @{$teaches{$prof}}));
	print "</td>\n";
	if ($razredni{$prof}) {
		print "<th>A$razredni{$prof}</th>\n";
	} else {
		print "<th></th>\n";
	}
	
	foreach $day (@days) {
		print "<th>$prof_num</th>\n";
		for ($i = 1; $i <= 7; $i++) {
                    $key = $prof."_".$day."_".$i;
                    if ($matrix{$key}) {
                        $razred = substr($matrix{$key}, 0, 1);
                        $odeljenja = substr($matrix{$key}, 1);
                        print "<td class='razred".substr($matrix{$key}, 0, 1)."'>$razred<sub>$odeljenja</sub></td>";
                    } elsif ($matrix{$prof."_".$day."_".($i-1)} && $matrix{$prof."_".$day."_".($i+1)}) {
                        print "<td align='center'>/</td>";
                        $rupa++;
                    } else 
                    {
                        print "<td>&nbsp;</td>";
                    }
#			if ($i == 7) {
#				print "<td>&nbsp;</td>";
#			}
		}

	}
	print "</tr>\n";
	$prof_num++;
}

print"
</table>";

#print"<p>Ukupno pauza: $rupa</p>";

print "      
</div>  
</body>         
</html>
";
