#!/bin/bash

#echo '$#='$#
#menu
while [ $# -gt 0 ]
do
	#quitter
	if [ "$1" == "quit" -o "$1" == "exit" -o "$1" == "-quit" -o "$1" == "-exit" ]
	then
		break
	#affiche la liste des variables
	elif [ "$1" == "vars" -o "$1" == "-vars" ]
	then
		vars_show
		shift
	#affiche la liste des variables avec les valeurs
	elif [ "$1" == "vars2" -o "$1" == "-vars2" ]
	then
		eval $VAR="${dirs[*]}"
		vars_show2
		shift
	#affiche le tableau correspondant à la variable
	elif [ "$1" == "show" -o "$1" == "-show" ]
	then
		var_show
		shift
	#affiche la variable
	elif [ "$1" == "show2" -o "$1" == "-show2" ]
	then
		echo -e "\e[32m$VAR=\e[0m${dirs[*]}"
		shift
	#affiche le nombre de dossier dans la variable
	elif [ "$1" == "number" -o "$1" == "-number" ]
	then
		echo ${#dirs[@]}
		shift
	#ajouter un dossier au début
	elif [ "$1" == "add_first" -o "$1" == "-add_first" ]
	then
		if [ $# -lt 2 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_before 0 $2
		shift 2
	#ajouter un dossier avant un dossier existant (2 args)
	elif [ "$1" == "add_before" -o "$1" == "-add_before" ]
	then
		if [ $# -lt 3 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_before $2 $3
		shift 3
	#ajouter un dossier après un dossier existant (2 args)
	elif [ "$1" == "add_after" -o "$1" == "-add_after" ]
	then
		if [ $# -lt 3 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_after $2 $3
		shift 3
	#ajouter un dossier à la fin
	elif [ "$1" == "add_last" -o "$1" == "-add_last" ]
	then
		if [ $# -lt 2 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_after $((dirsize-1)) $2
		shift 2
	#supprime le premier dossier
	elif [ "$1" == "delete_first" -o "$1" == "-delete_first" ]
	then
		delete 0
		shift
	#supprime un dossier
	elif [ "$1" == "delete" -o "$1" == "-delete" ]
	then
		if [ $# -lt 2 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		delete $2
		shift 2
	#supprime le premier dossier
	elif [ "$1" == "delete_last" -o "$1" == "-delete_last" ]
	then
		delete $((dirsize-1))
		shift
	#déplace un dossier d'une ou plusieurs position vers le haut
	elif [ "$1" == "move_up" -o "$1" == "-move_up" ]
	then
		if [ $# -lt 3 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $2 -lt 0 -o $2 -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect index\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $((2-$3)) -lt 0 -o $((2-$3)) -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect diff value\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		moveup $2 $3
		shift 3
	#déplace un dossier d'une ou plusieurs position vers le bas
	elif [ "$1" == "move_down" -o "$1" == "-move_down" ]
	then
		if [ $# -lt 3 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $2 -lt 0 -o $2 -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect index\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $((2-$3)) -lt 0 -o $((2-$3)) -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect diff value\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		movedown $2 $3
		shift 3
	#remplace le nom d'un dossier
	elif [ "$1" == "update" -o "$1" == "replace" -o "$1" == "-update" -o "$1" == "-replace" ]
	then
		if [ $# -lt 3 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		replace $2 $3
		shift 3
	#afficher l'aide
	elif [ "$1" == "help" -o "$1" == "-help" ]
	then
		my_help2
		shift
	else
		echo -e "\e[1;31mERROR : unknown command\e[0m"
		echo '' #blank line skipped because of continue
		shift
		continue
	fi
	echo '' #blank line
done
