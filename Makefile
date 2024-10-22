SECTIONS=sec/intro.tex sec/set.tex sec/set-refinement.tex sec/lattice.tex sec/lattice-refinement.tex sec/appendix.tex
PACKAGE=equiv-ver
FLAGS=-halt-on-error

all: main.pdf

%.pdf: %.tex lib.bib $(SECTIONS)
	pdflatex $(FLAGS) $<
	- bibtex $*
	pdflatex $(FLAGS) $<
	pdflatex $(FLAGS) $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	  do pdflatex $<; done

clean:
	$(RM) *.log *.aux *.cfg *.glo *.idx *.toc *.ilg *.ind *.out *.lof *.lot \
              *.bbl *.blg *.gls *.cut *.hd  *.dvi *.ps  *.thm *.tgz *.zip *.rpi

distclean: clean
	$(RM) $(PDF) *-converted-to.pdf

archive: all clean
	tar -C .. -czvf $(PACKAGE).tgz \
          --exclude '*~'    --exclude '*.tgz' \
          --exclude '*.zip' --exclude '.git*' $(PACKAGE) 

zip: all clean
	zip -r  $(PACKAGE).zip * -x '*~' -x '*.tgz' -x '*.zip'
