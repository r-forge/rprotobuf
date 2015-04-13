article=jss1313
all: clean ${article}.pdf

clean:
	rm -fr ${article}.out ${article}.aux ${article}.log ${article}.bbl \
	  ${article}.blg ${article}.brf figures/fig-???.pdf

${article}.pdf: ${article}.Rnw
	R CMD Sweave ${article}.Rnw
	pdflatex ${article}.tex
	bibtex ${article}
	pdflatex ${article}.tex
	pdflatex ${article}.tex
	R CMD Stangle ${article}.Rnw

jssarchive:
	(cd .. && zip -r jss1313_submission_$$(date "+%Y-%m-%d").zip jss/ -x "jss/JSSstyle/*" -x "jss/JSSemails/*")
