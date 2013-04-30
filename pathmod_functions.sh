#!/bin/bash

## add :
## export BASHPID=$$
## to ~/.bashrc if bash < 4.0-alpha

#fonction pour quitter correctement, peu importe le mode d'appel (source ou non)
function quitter() {
	# $BASHPID est le pid de la console bash
	# $$ est le pid du processus courant
	# $BASH_SUBSHELL vaux 0 si on est dans la console bash
	if [ $BASHPID -eq $$ ]
	#if [ $BASH_SUBSHELL -eq 0 ]
	then
		return
	else
		exit 1
	fi
}

#affiche la liste des dossiers
function var_show() {
	echo -e "\e[32m$VAR=\e[0m"
	echo "Number of items in original array: ${#dirs[@]}"
	for i in ${!dirs[@]}
	do
		printf "%4d = %s\n" $i ${dirs[$i]}
	done
}

#vérifie l'usage de pathmod2
function chk_usage() {
	#echo $#
	if [ $# -le 0 ]
	then
		VAR=PATH
		#echo $#
		#echo "Usage:"
		#echo -e "\t$0 -help\t pour l'aide"
		return 0
	elif [ $# -eq 1 ]
	then
		if [[ ":$VARS:" == *":$1:"* ]]
		then
			VAR=$1
			shift
			#echo $#
			return 1
		else
			VAR=PATH
			#shift #only if >1 args
			#echo $#
			return 0
		fi
	else
		#echo $#
		if [[ ":$VARS:" == *":$1:"* ]]
		then
			VAR=$1
			shift
			#echo $#
			return 1
		else
			VAR=PATH
			#shift #only if >1 args
			#echo $#
			return 0
		fi
	fi
}

#affiche la liste des variables
#declare -r VARS="CDPATH:CPATH:C_INCLUDE_PATH:CPLUS_INCLUDE_PATH:OBJC_INCLUDE_PATH:LD_LIBRARY_PATH:LD_RUN_PATH:LIBRARY_PATH:MANPATH:PATH:PERL5LIB:PERLLIB:PKG_CONFIG_PATH";
VARS="CDPATH:CPATH:C_INCLUDE_PATH:CPLUS_INCLUDE_PATH:OBJC_INCLUDE_PATH:LD_LIBRARY_PATH:LD_RUN_PATH:LIBRARY_PATH:MANPATH:PATH:PERL5LIB:PERLLIB:PKG_CONFIG_PATH";
function vars_show() {
	IFS=:
	#VARS="CDPATH:CPATH:C_INCLUDE_PATH:CPLUS_INCLUDE_PATH:OBJC_INCLUDE_PATH:LD_LIBRARY_PATH:LD_RUN_PATH:LIBRARY_PATH:MANPATH:PERL5LIB:PERLLIB:PKG_CONFIG_PATH";
	for dir in $VARS
	do
		echo $dir
	done
}
function vars_show2() {
	IFS=:
	#VARS="CDPATH:CPATH:C_INCLUDE_PATH:CPLUS_INCLUDE_PATH:OBJC_INCLUDE_PATH:LD_LIBRARY_PATH:LD_RUN_PATH:LIBRARY_PATH:MANPATH:PERL5LIB:PERLLIB:PKG_CONFIG_PATH";
	for dir in $VARS
	do
		echo -ne "\e[32m""$dir=""\e[0m"
		echo "${!dir}"
	done
}

#aide
function my_help() {
	echo -e "\e[34mLISTE DES COMMANDES :\e[0m"
	#echo -e "vars\tAffiche une liste de variables modifiables"
	echo -e "show\tAffiche le contenu du tableau (PATH)"
	#echo -e "show2\tAffiche (PATH)"
	echo -e "quit\tQuitte le programme"
	echo -e "exit\tQuitte le programme"
	echo -e "help\tAffiche cette aide"
	#echo -e "add_first(\$d)\tAjoute un dossier \$d au début"
	echo -e "add_before(\$n,\$d)\tAjoute un dossier \$d avant le dossier n° \$n"
	echo -e "add_after(\$n,\$d)\tAjoute un dossier \$d après le dossier n° \$n"
	#echo -e "add_last(\$d)\tAjoute un dossier \$d à la fin"
	#echo -e "delete_first\tEfface le premier dossier"
	echo -e "delete(\$n)\tEfface le dossier n° \$n"
	#echo -e "delete_last\tEfface le dernier dossier"
	#echo -e "update(\$n,\$d)\tMet à jour le dossier \$d à la \$n position"
	#echo -e "replace(\$n,\$d)\tMet à jour le dossier \$d à la \$n position"
	echo -e "move_up($n,$m)\tDeplace le dossier n° \$n de \$m position vers le haut"
	echo -e "move_down($n,$m)\tDeplace le dossier n° \$n de \$m position vers le bas"
}

#aide2
function my_help2() {
	echo -e "\e[34mLISTE DES COMMANDES :\e[0m"
	echo -e "vars\t""\e[1;32m0\e[0m ""Affiche une liste de variables modifiables"
	echo -e "show\t""\e[1;32m0\e[0m ""Affiche le contenu du tableau (PATH)"
	echo -e "show2\t""\e[1;32m0\e[0m ""Affiche (PATH)"
	echo -e "quit\t""\e[1;32m0\e[0m ""Quitte le programme"
	echo -e "exit\t""\e[1;32m0\e[0m ""Quitte le programme"
	echo -e "help\t""\e[1;32m0\e[0m ""Affiche cette aide"
	echo -e "add_first(\$d)\t""\e[1;32m1\e[0m ""Ajoute un dossier \$d au début"
	echo -e "add_before(\$n,\$d)\t""\e[1;32m2\e[0m ""Ajoute un dossier \$d avant le dossier n° \$n"
	echo -e "add_after(\$n,\$d)\t""\e[1;32m2\e[0m ""Ajoute un dossier \$d après le dossier n° \$n"
	echo -e "add_last(\$d)\t""\e[1;32m1\e[0m ""Ajoute un dossier \$d à la fin"
	echo -e "delete_first\t""\e[1;32m0\e[0m ""Efface le premier dossier"
	echo -e "delete(\$n)\t""\e[1;32m1\e[0m ""Efface le dossier n° \$n"
	echo -e "delete_last\t""\e[1;32m0\e[0m ""Efface le dernier dossier"
	echo -e "update(\$n,\$d)\t""\e[1;32m2\e[0m ""Met à jour le dossier \$d à la \$n position"
	echo -e "replace(\$n,\$d)\t""\e[1;32m2\e[0m ""Met à jour le dossier \$d à la \$n position"
	echo -e "move_up(\$n,\$m)\t""\e[1;32m2\e[0m ""Deplace le dossier n° \$n de \$m position vers le haut"
	echo -e "move_down(\$n,\$m)\t""\e[1;32m2\e[0m ""Deplace le dossier n° \$n de \$m position vers le bas"
}

#vérifie la méthode d'appel
function chk_call() {
	#vérifier mode d'appel
	if [ $DEBUG -eq 1 ]
	then
		if [ "$BASHPID" -eq $$ ]
		#if [ $BASH_SUBSHELL -eq 0 ]
		then
			echo -e '\e[1;31mERROR : launch with ./pathmod.sh while in DEBUG MODE\e[0m'
			quitter;
		fi
	elif [ $DEBUG -eq 0 ]
	then
		if [ $BASHPID -ne $$ ]
		#if [ $BASH_SUBSHELL -eq 0 ]
		then
			echo -e '\e[1;31mERROR : launch with . ./pathmod.sh OR source ./pathmod.sh\e[0m'
			quitter;
		fi
	else
		echo -e '\e[1;31mERROR : invalide DEBUG value\e[0m'
		quitter;
	fi
}

#vérifie nb dossiers
function chk_nb_dirs() {
	#vérifie nombre de dossier : ERREUR si == 1 et PATH contient :
	if [ ${#dirs[@]} -eq 1 -a `expr index "$PATH" ':'` -ne 0 ]
	then
		echo $dirs
		echo -e "\e[1;31mERROR : 1 element only\e[0m"
		quitter;
	fi
}

function add_before() {
	IFS=
	#vérifier s'il y a rien avant
	if [ $1 -eq 0 ]
	then
		dirs=( "$2" ${dirs[@]} )
	else
		dirs=( ${dirs[@]:0:$1-1} "$2" ${dirs[@]:$1} )
	fi
	IFS=:
	dirsize=${#dirs[@]}
}

function add_after() {
	IFS=
	#vérifier s'il y a rien après
	if [ $1 -eq ${#dirs[@]} ]
	then
		dirs=( ${dirs[@]:0:$1+1} "$2" )
	else
		dirs=( ${dirs[@]:0:$1+1} "$2" ${dirs[@]:$1+1} )
	fi
	IFS=:
	dirsize=${#dirs[@]}
}

function delete() {
	IFS=
	#vérifier qu'il y a rien avant
	if [ $1 -eq 0 ]
	then
		dirs=( ${dirs[@]:1} )
	else
		#vérifier qu'il y a rien après
		if [ $1 -eq ${#dirs[@]} ]
		then
			dirs=( ${dirs[@]:0:$1} )
		else
			dirs=( ${dirs[@]:0:$1} ${dirs[@]:$1+1} )
		fi
	fi
	IFS=:
	dirsize=${#dirs[@]}
}

function moveup() {
	IFS=
	dirs=( ${dirs[@]:0:$1-$2} ${dirs[$1]} ${dirs[@]:$1-$2:$2} ${dirs[@]:$1+1} )
	IFS=:
}

function movedown() {
	IFS=
	dirs=( ${dirs[@]:0:$1} ${dirs[@]:$1+1:$2} ${dirs[$1]} ${dirs[@]:$1+$2+1} )
	IFS=:
}

function replace() {
	IFS=
	#vérifier s'il y a rien avant
	if [ $1 -eq 0 ]
	then
		dirs=( "$2" ${dirs[@]:1} )
	else
		#dirs=( ${dirs[@]:0:$1-1} "$2" ${dirs[@]:$1} )
		#vérifier qu'il y a rien après
		if [ $1 -eq ${#dirs[@]} ]
		then
			dirs=( ${dirs[@]:0:$1} "$2" )
		else
			dirs=( ${dirs[@]:0:$1} "$2" ${dirs[@]:$1+1} )
		fi
	fi
	IFS=:
}

#end
