#!/usr/bin/env bash

SUCCESS="\033[32;1m✓\033[0m"
WARNING="\033[33;1m!\033[0m"
ERROR="\033[31;1m✗\033[0m"

function install_bat_config {
	local_path=$1

	if command -v ${command} 2>&1 >/dev/null; then
		bat_config="$(bat --config-dir)/syntaxes"
		mkdir -p "${bat_config}"
		ln -s "${local_path}/SDML" "${bat_config}/SDML"
		echo "${SUCCESS} Linked local Git repository into bat configuration."
		if bat cache --build; then
			echo "${SUCCESS} Bat cache updated."
		else
			echo "${ERROR} Bat cache failed to update."
			exit 1
		fi
	else
		echo "${WARNING} Bat not installed, no install action taken."
	fi
}

function install_sublime_package {
	local_path="$1"

	if [[ ! -d ${local_path} ]]; then
	    if git clone https://github.com/sdm-lang/sdml-sublime-text.git "${local_path}"; then
	        echo "${SUCCESS} Cloned sdml-sublime-text package in ${local_path}"
	    else
	        echo "${ERROR} Could not clone sdml-sublime-text package from repository";
	        exit 3
	    fi
	else
		pushd ${local_path} 2>&1 >/dev/null
		if git fetch; then
			echo "${SUCCESS} Local repository exists, fetched latest updates."
		else
			echo "${ERROR} Local repository exists, could not fetch latest updates."
		fi
		popd 2>&1 >/dev/null
	fi
}

echo "\033[1m"
cat <<EOF

        ___          _____          ___ 
       /  /\        /  /::\        /__/\ 
      /  /:/_      /  /:/\:\      |  |::\ 
     /  /:/ /\    /  /:/  \:\     |  |:|:\    ___     ___ 
    /  /:/ /::\  /__/:/ \__\:|  __|__|:|\:\  /__/\   /  /\ 
   /__/:/ /:/\:\ \  \:\ /  /:/ /__/::::| \:\ \  \:\ /  /:/ 
   \  \:\/:/~/:/  \  \:\  /:/  \  \:\~~\__\/  \  \:\  /:/ 
    \  \::/ /:/    \  \:\/:/    \  \:\         \  \:\/:/ 
     \__\/ /:/      \  \::/      \  \:\         \  \::/ 
       /__/:/        \__\/        \  \:\         \__\/ 
       \__\/                       \__\/ 
                      Domain                      Language
        Simple                      Modeling

EOF
echo "\033[0m"

library_path="${HOME}/Library/Application\ Support/Sublime\ Text/Packages/SDML"
install_sublime_package "${library_path}"
install_bat_config "${library_path}"
