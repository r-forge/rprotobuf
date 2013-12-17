all: clean RJwrapper.pdf

clean:
	rm -fr RJwrapper.pdf
	rm -fr RJwrapper.out
	rm -fr RJwrapper.aux
	rm -fr RJwrapper.log
	rm -fr RJwrapper.bbl
	rm -fr RJwrapper.blg
	rm -fr RJwrapper.brf

RJwrapper.pdf: RJwrapper.tex eddelbuettel-francois-stokely.Rnw RJournal.sty
	R CMD Sweave eddelbuettel-francois-stokely.Rnw
	pdflatex RJwrapper.tex
	bibtex RJwrapper
	pdflatex RJwrapper.tex
	pdflatex RJwrapper.tex
