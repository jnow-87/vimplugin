####
## commands
####

echo := @echo
cp := @cp -ru
mkdir := @mkdir -p
rm := @rm -rf


####
## config
####

# vim plugin sub-directories to consider
isplugin := plugin autoload ftplugin syntax doc

# vim directory, used as target
vim_dir := .vim


####
## collect list of plugin directories
####

# add prefix in order for following filter to work
isplugin := $(addprefix %/,$(isplugin))

# only consider the vim plugin directories listed in $(isplugin)
files := $(filter $(isplugin),$(patsubst ./%,%,$(shell find -type d)))

# add vimrc
files += $(patsubst ./%,%,$(shell find -type f -path *vimrc))

# do not consider the target directory
files := $(filter-out $(vim_dir)%,$(files))


####
## targets
####

.PHONY: all
all: clean
	$(mkdir) $(vim_dir)
	$(cp) $(files) $(vim_dir)

.PHONY: clean
clean:
	$(rm) $(vim_dir)
