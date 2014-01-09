all: clean article.pdf

clean:
	rm -fr article.{pdf,out,aux,log,bbl,blg,brf}

article.pdf: article.Rnw
	R CMD Sweave article.Rnw
	pdflatex article.tex
	bibtex article
	pdflatex article.tex
	pdflatex article.tex
