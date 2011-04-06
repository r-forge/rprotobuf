
all: RProtoBuf-unitTests.pdf RProtoBuf.pdf RProtoBuf-quickref.pdf

clean:
	rm -fr *.pdf

setvars:
ifeq (${R_HOME},)
R_HOME=	$(shell R RHOME)
endif
RPROG=	$(R_HOME)/bin/R
RSCRIPT=$(R_HOME)/bin/Rscript

RProtoBuf-unitTests.pdf: unitTests/RProtoBuf-unitTests.R
	$(RSCRIPT) --default-packages="RProtoBuf,Rcpp,brew,RUnit,tools,utils" unitTests/RProtoBuf-unitTests.R

RProtoBuf.pdf: RProtoBuf/RProtoBuf.Rnw
	touch RProtoBuf.Rnw
	rm RProtoBuf.Rnw
	cp RProtoBuf/RProtoBuf.Rnw RProtoBuf.Rnw
	$(RSCRIPT) -e "require( 'highlight' ); require('tools'); Sweave('RProtoBuf.Rnw', driver = HighlightWeaveLatex() ) ; texi2dvi('RProtoBuf.tex', pdf = TRUE, clean = TRUE)"
	rm -fr RProtoBuf.tex
	rm -fr RProtoBuf.Rnw
	rm -fr RProtoBuf.aux
	rm -fr RProtoBuf.log
	rm -fr RProtoBuf.out
	cp RProtoBuf/RProtoBuf-fake.Rnw RProtoBuf.Rnw

RProtoBuf-quickref.pdf: RProtoBuf-quickref/RProtoBuf-quickref.Rnw
	touch RProtoBuf-quickref.Rnw
	rm RProtoBuf-quickref.Rnw
	cp RProtoBuf-quickref/RProtoBuf-quickref.Rnw .
	$(RSCRIPT) -e "require( 'highlight' ); require('tools'); Sweave('RProtoBuf-quickref.Rnw', driver = HighlightWeaveLatex() ) ; texi2dvi('RProtoBuf-quickref.tex', pdf = TRUE, clean = TRUE)"
	rm -fr RProtoBuf-quickref.tex
	rm -fr RProtoBuf-quickref.Rnw
	rm -fr RProtoBuf-quickref.aux
	rm -fr RProtoBuf-quickref.log
	rm -fr RProtoBuf-quickref.out
	cp RProtoBuf-quickref/RProtoBuf-quickref-fake.Rnw RProtoBuf-quickref.Rnw

