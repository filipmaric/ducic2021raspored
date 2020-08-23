while(<STDIN>) {
	print "$1 " if (/^v (.*)$/);
}
