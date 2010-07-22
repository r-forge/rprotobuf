#!/usr/bin/r

require( utils )
require( highlight )
require( Rcpp )
require( inline )

basefile <- "slides"
rnwfile <- paste(basefile, ".Rnw", sep="")
texfile <- paste(basefile, ".tex", sep="")

driver <- HighlightWeaveLatex( boxes = TRUE )
Sweave( rnwfile, driver = driver )
tex <- readLines( texfile )
target <- "\\begin{minipage}[b]{.9\\textwidth}%"
tex[ tex == target ] <- "\\begin{minipage}[b]{.95\\textwidth}%"

target <- "\\vspace{1em}\\noindent\\fbox{\\begin{minipage}{0.9\\textwidth}"
tex[ tex == target ] <- "\\vspace{1em}\\noindent\\fcolorbox{highlightBorder}{highlightBg}{\\begin{minipage}{0.95\\textwidth}"

endboxes <- grep( "^\\\\mbox", tex )
tex[ endboxes - 1 ] <- sprintf( "%s \\mbox{}",
	sub( "\\\\\\\\$", "", tex[ endboxes - 1 ] ) )
tex[ endboxes ] <- ""

start <- grep( "<TINY>", tex )
end <- grep( "</TINY>", tex )
for( i in seq_along( start ) ){
	lines <- tex[ seq( start[i], end[i] ) ]
	lines <- gsub( "\\usebox{\\hlbox", "\\usebox{\\tinyhlbox", lines, fixed = TRUE )
	tex[ seq( start[i], end[i] ) ] <- lines
}

writeLines( tex, texfile )
tools::texi2dvi( texfile, pdf = TRUE, clean = TRUE )

