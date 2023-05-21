####
## config
####

PREFIX ?= .vim

echo := @echo
build := @scripts/build.sh

ifneq ($V,0)
  verbose := $(if $V,verbose)
endif


####
## targets
####

.PHONE: help
help:
	$(echo) "(un)install plugins.\n"
	$(echo) "Variables:"
	$(echo) "    V       enable verbose output"
	$(echo) "    PREFIX  target directory, default=$(PREFIX)"

.PHONY: install
install:
	$(build) install . $(PREFIX) $(verbose)

.PHONY: uninstall
uninstall:
	$(build) uninstall . $(PREFIX) $(verbose)
