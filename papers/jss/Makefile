all: clean article.pdf

clean:
	rm -fr article.pdf
	rm -fr article.out
	rm -fr article.aux
	rm -fr article.log
	rm -fr article.bbl
	rm -fr article.blg
	rm -fr article.brf

article.pdf: article.Rnw
	R CMD Sweave article.Rnw
	pdflatex article.tex
	bibtex article
	pdflatex article.tex
	pdflatex article.tex
