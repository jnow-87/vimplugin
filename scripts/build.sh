#!/usr/bin/env bash
#
# Create/remove ($1) a .vim directory at ($3) based on the plugins found in $2.
# If $4 is given, verbose output is enabled.



readonly VIM_PLUGIN_FILES="plugin autoload ftplugin ftdetect syntax doc snippets vimrc"


function main(){
	local op=$1
	local root_dir=$2
	local build_tree=$3
	local vim_plugin_files=$(echo ${VIM_PLUGIN_FILES} | sed -e 's: :\\|:g')

	for plugin in $(ls -d ${root_dir}/* | grep -wv -e "${build_tree}")
	do
		for plugin_file in $(ls -1 ${plugin} | grep -wo -e "${vim_plugin_files}")
		do
			for file in $(ls -1 ${plugin}/${plugin_file});do
				# for files, ls prints the file including its path
				# for directories, ls prints the content of it, without its path
				if [ -f ${file} ];then
					local src="${file}"
					local tgt="${build_tree}/${plugin_file}"

				else
					local src="${plugin}/${plugin_file}/${file}"
					local tgt="${build_tree}/${plugin_file}/${file}"
				fi

				# (un)install
				if [ "$1" == "install" ];then
					[ "$4" != "" ] && echo "[INSTALL] ${src} -> ${tgt}"

					# if a link to a directory already exists, the new link is
					# created within it, i.e. within the targets repository to
					# avoid this, remove it
					[ -L ${tgt} ] && rm -f ${tgt}

					mkdir -p $(dirname ${tgt})
					ln -srf ${src} ${tgt}

				else
					[ "$4" != "" ] && echo "[RM] ${tgt}"
					rm -f ${tgt}
				fi
			done
		done
	done
}


if [ $# -ge 3 ];then
	set -e
	main $1 "$2" "$3" $4

else
	echo "usage: $0 <install|uninstall> <plugin directory> <output directory> [verbose]"
	exit 1
fi
