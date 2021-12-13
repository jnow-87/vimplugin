####
## config
####

build_tree := .vim
plugin_tree := .

build_script := scripts/build.sh


####
## targets
####

.PHONY: all
all: clean
	$(build_script) $(plugin_tree) $(build_tree)

.PHONY: install
install:
	cp -r $(build_tree) ~/

.PHONY: clean
clean:
	rm -rf $(build_tree)
