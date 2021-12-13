#!/usr/bin/env bash
# create a .vim directory ($2) based on the plugins found in $1


readonly VIM_PLUGIN_FILES="plugin autoload ftplugin ftdetect syntax doc snippets vimrc"


function main(){
	local root_dir=$1
	local build_tree=$2
	local vim_plugin_files=$(echo ${VIM_PLUGIN_FILES} | sed -e 's: :\\|:g')

	for plugin in $(ls -d ${root_dir}/*)
	do
		for plugin_file in $(ls -1 ${plugin} | grep -wo -e ${vim_plugin_files})
		do
			for file in $(ls -1 ${plugin}/${plugin_file});do
				# ls -1 is given a file it prints the file including the directories
				# on the way for directories the content of them is printed without
				# the directories it is contained in
				if [ -f ${file} ];then
					local src="${file}"
					local tgt="${build_tree}/${plugin_file}"

				else
					local src="${plugin}/${plugin_file}/${file}"
					local tgt="${build_tree}/${plugin_file}/${file}"
				fi

				# create the link
				mkdir -p $(dirname ${tgt})
				ln -s ${src} ${tgt}
			done
		done
	done
}


[ $# -ge 2 ] || { echo "usage: $0 <plugin directory> <output directory>"; exit 1; }

set -e
main "$(readlink -f $1)" "$2"
