FILE = ducic2020.csv
DAYS = days

raspored : out
	perl runpretty.pl out > raspored && less raspored

html/index.html : out
	perl html.pl < out
	perl kompletan_spisak.pl < out > html/raspored.html

out : model
	perl fromDimacs.pl < model | grep -v "^-" | egrep ".*_.*_[^.]*[.][^.]*[.][0-9]+_.*_.*" > out

model.tmp : formula.dimacs
	-./plingeling formula.dimacs -v > model.tmp

model : formula.dimacs model.tmp
#	./yices -e -d -v 100 formula.dimacs > model
	perl dimacs_out_process.pl < model.tmp > model

formula.dimacs : formula.tmp $(DAYS) osnova 2dimacs
	cat formula.tmp $(DAYS) osnova | ./2dimacs coding > formula.dimacs.tmp
	./last-first.sh formula.dimacs.tmp > formula.dimacs
	rm formula.dimacs.tmp

formula.tmp : $(FILE) formula
	./formula < $(FILE) > formula.tmp

formula : main.cpp
	g++ -O3 main.cpp -o formula

2dimacs : 2dimacs.cpp
	g++ -O3 -o 2dimacs 2dimacs.cpp

filter:
	perl showDimacs.pl  < core | egrep "^[a-z]+_[0-9]{2}[ab]_[a-z0-9.]+_[a-z]{3}_[0-9][ ]*$$"  > core.tmp
	wc -l core.tmp
	head -10 core.tmp | tr -d " " > core
	grep -v -f core osnova  > osnova.tmp
	mv osnova.tmp osnova
	wc -l osnova
	rm model.tmp
	rm core
