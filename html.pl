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


while($line = <STDIN>) {
	if ($line =~ /^([^_]*)_([^_]*)_([^_]+)[.](p|v)[.][0-9]+_(pon|uto|sre|cet|pet)_([0-9]+)$/) {
		$teacher = $1;
		$group = $2;
		$subject = $3;
		$day = $5;
		$hour = $6;
		
		$key = $teacher."_".$day."_".$hour;
                $group_link = "<span><a href='$group.html'>$group</a></span>";
		if ($matrix_teacher{$key}) {	
                    $matrix_teacher{$key} = "$group_link, " . $matrix_teacher{$key};
		} else {
                    $subject_link = "<span>$subjects{$subject}</span>";
                    $matrix_teacher{$key} = "$group_link<br>$subject_link";
		}

		$key = $group."_".$day."_".$hour;
                $teacher_link = "<span><a href='$teacher.html'>$teachers{$teacher}</a></span>";
                $subject_link = "<span><b>$subjects{$subject}</b></span>";
                if ($matrix_group{$key}) {
                    $matrix_group{$key} = "$teacher_link<br>$subject_link<br>" . $matrix_group{$key};
                } else {
                    $matrix_group{$key} = "$teacher_link<br>$subject_link";
                }
		$groups{$group} = 1;
	} elsif ($line =~ /teacher: (.*)/) {
		$teacher = $1;
	}
}

@days = ("pon", "uto", "sre", "cet", "pet");

foreach $prof (sort keys(%teachers)) {
	open(FILE, ">html/$prof.html");

print FILE "
<html>
<title>Raspored časova</title>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<head>
<link rel='stylesheet' type='text/css' href='matf.css' />
<link rel='stylesheet' type='text/css' href='matf_timetable.css' />
</head>
<body>
<div style='width : 950px; margin-left : auto'>
<h2  align='center'>
<a href='index.html'>Raspored časova</a>
</h2>
";

print FILE "<h2 align='center'>".$teachers{$prof}."</h2>";

print FILE "
<table class='timetable' cellspacing='1px' align='center'>
<tr><th></th>
<th class='timetable'>Ponedeljak</th>
<th class='timetable'>Utorak</th>
<th class='timetable'>Sreda</th>
<th class='timetable'>Četvrtak</th>
<th class='timetable'>Petak</th>
</tr>
";

	for ($i = 1; $i <= 7; $i++) {
		print FILE "<tr>";
		print FILE "<th class='timetable' width='20'>$i</th>";
		foreach $day (@days) {
			$printed = 0;
			
			if ($matrix_teacher{$prof."_".$day."_".$i}) {
				print FILE "<td class='smena13'>".($matrix_teacher{$prof."_".$day."_".$i})."</td>";
				$printed = 1;
			} 
			
			if ($matrix_teacher{$prof."_".$day."_".($i+7)}){
				die "$prof" if ($printed);
				print FILE "<td class='smena24'>".$matrix_teacher{$prof."_".$day."_".($i+7)}."</td>";
				$printed = 1;
			}
			
			if (!$printed) {
				print FILE "<td class='timetable'>&nbsp;</td>";
			}
		}
		print FILE "</tr>\n";
	}
	
	print FILE "</table>\n";
	close(FILE);
}


foreach $group (sort keys(%groups)) {
	open(FILE, ">html/$group.html");

print FILE "
<html>
<title>Raspored časova</title>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<head>
<link rel='stylesheet' type='text/css' href='matf.css' />
<link rel='stylesheet' type='text/css' href='matf_timetable.css' />
</head>
<body>
<div style='width : 950px; margin-left : auto'>
<h2  align='center'>
<a href='index.html'>Raspored časova</a>
</h2>
";

print FILE "
<table class='timetable' cellspacing='1px' align='center'>
<tr><th></th>
<th class='timetable'>Ponedeljak</th>
<th class='timetable'>Utorak</th>
<th class='timetable'>Sreda</th>
<th class='timetable'>Četvrtak</th>
<th class='timetable'>Petak</th>
</tr>
";

	for ($i = 1; $i <= 7; $i++) {
		print FILE "<tr>";
		print FILE "<th class='timetable' width='20'>$i</th>";
		foreach $day (@days) {
			$entry = $matrix_group{$group."_".$day."_".$i} . $matrix_group{$group."_".$day."_".($i+7)};
			if ($entry) {
				print FILE "<td class='timetable' style='color:#666666'>".$entry."</td>";
			} else {
				print FILE "<td class='timetable'>&nbsp;</td>";
			}
		}
		print FILE "</tr>\n";
	}
	
	print FILE "</table>\n";
	close(FILE);
}
