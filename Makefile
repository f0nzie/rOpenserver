# based on https://github.com/yihui/knitr/blob/master/Makefile
# prepare the package for release
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: check

docs:
	R -q -e 'library(Rd2roxygen); rab(".", build = FALSE)'


build:
	cd ..;\
	R CMD build --no-manual $(PKGSRC)

build-cran:
	cd ..;\
	R CMD build $(PKGSRC)


check: build-cran
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran


install2: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz


install:
	# identical to RStudio Install and Restart
	cd ..;\
	Rscript -e "devtools::document(pkg = '$(PKGNAME)', roclets = c('rd', 'collate', 'namespace'))";\
	Rcmd.exe INSTALL --no-multiarch --with-keep.source $(PKGNAME)

pkgdown: README.md install
	# build documentation website
	Rscript -e "pkgdown::build_site(preview = TRUE)"

test:
	Rscript -e "devtools::test()"


README.md: README.Rmd
	Rscript --vanilla -e 'library(rmarkdown);render("$<")'


clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/
