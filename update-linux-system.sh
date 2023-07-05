#!/usr/bin/bash -e

# Note: The -e flag will cause the script to exit if any command fails.

# Description: Update all the packages of a linux system
# Author: @nothingbutlucas
# Version: 1.0.0
# License: GNU General Public License v3.0

# Colours and uses

red='\033[0;31m'    # Something went wrong
green='\033[0;32m'  # Something went well
yellow='\033[0;33m' # Warning
blue='\033[0;34m'   # Info
purple='\033[0;35m' # When asking something to the user
cyan='\033[0;36m'   # Something is happening
grey='\033[0;37m'   # Show a command to the user
nc='\033[0m'        # No Color

sign_wrong="${red}[-]${nc}"
sign_good="${green}[+]${nc}"
sign_warn="${yellow}[!]${nc}"
sign_info="${blue}[i]${nc}"
sign_ask="${purple}[?]${nc}"
sign_doing="${cyan}[~]${nc}"
sign_cmd="${grey}[>]${nc}"

wrong="${red}"
good="${green}"
warn="${yellow}"
info="${blue}"
ask="${purple}"
doing="${cyan}"
cmd="${grey}"

trap ctrl_c INT

function ctrl_c() {
	exit_script
}

function language_os() {
	echo "${LANG}" | cut -d'_' -f1
}

function detect_language() {
	language=$(language_os)

	if [[ $language == "es" ]]; then
		text_joke00="Hackeando su sistema..."
		text_joke01="Obteniendo todos sus datos personales..."
		text_joke02="Joda!"
		text_joke03="¿Ejecutaste un .sh sin chequearlo antes? Espero que no!"
		text_explain00="Bueno, estas a punto de actualizar todos los paquetes de tu sistema."
		text_explain01="Es importante saber que paquetes estas actualizando porque si algo falla después de la actualización, sabes que paquete vas a 'rollbackear' a la version anterior."
		text_explain02="Si no queres ver este mensaje de nuevo usa la opción -e"
		text_continue00="¿Quieres continuar? (s/N) "
		text_continue01="Continuando... "
		text_exiting="Saliendo del script"
		text_starting="Iniciando script"
		text_need_root="Necesitas ser root para ejecutar este script"
		text_not_need_root="No necesitas ser root para ejecutar este script"
		text_are_root="Ejecutando como root"
		text_not_root="Ejecutando como $USER"
		text_example00="Simple:    "
		text_example01="Charlatán: "
		text_example01_comment="# Esto activa el modo charlatán (verbose)"
		text_example02="Silencioso:"
		text_example02_comment="# Esto activa el modo silencioso (quiet)"
		text_example03="Experto:   "
		text_example03_comment="# Esto activa el modo experto"
		text_checking_installed00="Comprobando si"
		text_checking_installed01="está instalado"
		text_update00="Actualizando paquetes con"
		text_not_installed="no está instalado"
		text_incompatible_modes="El modo charlatán y el modo silencioso no pueden estar activados al mismo tiempo, se activará el modo charlatán"
		text_invalid="Opción inválida"
		text_usage="Uso:"
		text_modes="Modos:"
	else
		text_joke00="Hacking your system..."
		text_joke01="Obtaining all your personal data..."
		text_joke02="Joking!"
		text_joke03="Do u execute an .sh file without checking it? I hope not"
		text_explain00="So you are about to update all the packages of your system."
		text_explain01="It's important that you know what packages where updated because if somethings breaks after the update know what package you have to rollback."
		text_explain02="If you don't want to see this message again use -e option."
		text_continue00="Do you want to continue? (y/N) "
		text_continue01="Continuing... "
		text_exiting="Exiting script"
		text_starting="Starting script"
		text_need_root="You need to be root to run this script"
		text_not_need_root="You don't need to be root to run this script"
		text_are_root="Executing as root"
		text_not_root="Executing as $USER"
		text_example00="Simple: "
		text_example01="Verbose:"
		text_example01_comment="# This enables verbose mode"
		text_example02="Quiet:  "
		text_example02_comment="# This enables quiet mode"
		text_example03="Expert: "
		text_example03_comment="# This enables expert mode"
		text_checking_installed00="Checking if"
		text_checking_installed01="is installed"
		text_update00="Updating packages with"
		text_not_installed="is not installed"
		text_incompatible_modes="Verbose and quiet mode cannot be enabled at the same time, verbose mode will be enabled"
		text_invalid="Invalid option"
		text_usage="Usage:"
		text_modes="Modes:"
	fi

}

function exit_script() {
	echo -e "${sign_good} ${text_exiting}"
	tput cnorm
	exit 0
}

function start_script() {
	tput civis
	echo ""
	echo -e "${sign_good} ${text_starting}"
}

function verify_root() {
	noot_or_not=n
	if [[ $root_or_not == "y" ]]; then
		if [[ $(id -u) -ne 0 ]]; then
			echo -e "${sign_wrong} ${text_need_root}" 1>&2
			exit_script
		else
			echo -e "${sign_good} ${text_are_root}"
		fi
	else
		if [[ $(id -u) == 0 ]]; then
			echo -e "${sign_wrong} ${text_not_need_root}" 1>&2
			exit_script
		else
			echo -e "${sign_good} ${text_not_root}"
		fi
	fi
}

function help_panel() {
	echo -e "\n${text_usage} ${good}$0${nc}"
	echo -e "\n${text_modes}"
	echo -e "\t${sign_info} ${info} ${text_example00} ${cmd} $0 ${nc}"
	echo -e "\t${sign_info} ${info} ${text_example01} ${cmd} $0 ${good}-v ${warn}${text_example01_comment}${nc}"
	echo -e "\t${sign_info} ${info} ${text_example02} ${cmd} $0 ${good}-q ${warn}${text_example02_comment}${nc}"
	echo -e "\t${sign_info} ${info} ${text_example03} ${cmd} $0 ${good}-e ${warn}${text_example03_comment}${nc}"
	echo -e ""
	exit_script
}

function echo() {
	if [[ $quiet == false ]]; then
		/usr/bin/echo "$@"
	fi
}

function echo_verbose() {
	if [[ $verbose == true ]]; then
		/usr/bin/echo "$@"
	fi
}

function no_expert() {
	/usr/bin/echo -e "${sign_doing} ${text_joke00}"
	sleep 1
	/usr/bin/echo -e "${sign_doing} ${text_joke01}"
	sleep 0.5
	/usr/bin/echo -e "${sign_good} ${text_joke02}"
	sleep 1
	/usr/bin/echo -e "${sign_ask} ${text_joke03}"
	sleep 2
	/usr/bin/echo -e "${sign_info} ${text_explain00}"
	sleep 1
	/usr/bin/echo -e "${sign_info} ${text_explain01}"
	sleep 3
	/usr/bin/echo -e "${sign_info} ${text_explain02}"
	sleep 1

	while true; do
		read -r -p "[?] ${text_continue00}" sn
		case $sn in
		[yYsS]*)
			/usr/bin/echo -e "${sign_good} ${text_continue01}"
			break
			;;
		*)
			exit_script
			;;
		esac
	done
}

# Main function

function main() {

	managers=(apt-get apt yum dnf zypper pacman emerge urpmi flatpak snap snapd pkg)

	for manager in "${managers[@]}"; do
		echo_verbose -e "\n${sign_doing} ${text_checking_installed00} ${manager} ${text_checking_installed01}"
		if command -v "$manager" &>/dev/null; then
			manager_absolute_path=$(which "$manager")
			echo -e "\n${sign_good} ${manager} -> ${manager_absolute_path}"
			echo -e "${sign_doing} ${text_update00} ${manager}"
			echo ""
			tput cnorm
			if [[ $manager == "pacman" ]]; then
				if [[ $quiet == false ]]; then
					sudo "${manager_absolute_path}"-Syu
				else
					sudo "${manager_absolute_path}" -Syu &>/dev/null
				fi
			else
				if [[ $quiet == false ]]; then
					sudo "${manager_absolute_path}" update -y && sudo "${manager_absolute_path}" upgrade -y
				else
					sudo "${manager_absolute_path}" update -y &>/dev/null && sudo "${manager_absolute_path}" upgrade -y &>/dev/null
				fi
			fi
			tput civis
		else
			echo_verbose -e "${sign_warn} ${manager} ${text_not_installed}"
		fi
	done
}

# Script starts here

verbose=false
quiet=false
expert=false

detect_language

while getopts ":vqhe" arg; do
	case $arg in
	v) verbose=true ;;
	q) quiet=true ;;
	e) expert=true ;;
	h) help_panel ;;
	?)
		echo -e "${sign_wrong} ${text_invalid} -> ${wrong}-$OPTARG${nc}\n"
		help_panel
		;;
	esac
done

verify_root

if [[ $verbose == true ]] && [[ $quiet == true ]]; then
	quiet=false
	echo -e "${sign_warn} ${text_incompatible_modes}${nc}"
	sleep 1
fi

if [[ $expert == false ]]; then
	no_expert
fi

start_script
main
exit_script
