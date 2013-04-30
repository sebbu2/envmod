#!/bin/bash

#menu
while true
do
	echo -e "\e[34mChoix\e[0m de l'opération à éffectuer [help pour l'aide]"
	read -e
	ret=$?
	#quitter la boucle
	if [ $ret -eq 1 ]
	then
		break;
	elif [ "$REPLY" == "quit" -o "$REPLY" == "exit" ]
	then
		break
	elif [ "$REPLY" == "show" ]
	then
		dirs_show
	elif [ "$REPLY" == "show2" ]
	then
		echo -e "\e[32mDIRS=\e[0m = ${dirs[*]}"
	#ajouter un dossier avant un dossier existant (2 args)
	elif [ "${REPLY%% *}" == "add_before" ]
	then
		id1=`expr index "$REPLY" ' '`
		string=${REPLY#* }
		id2=`expr index "$string" ' '`
		idx=${string%% *}
		string=${string#* }
		if [ $id1 -eq 0 -o $id2 -eq 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_before $idx $string
	#ajouter un dossier après un dossier existant (2 args)
	elif [ "${REPLY%% *}" == "add_after" ]
	then
		id1=`expr index "$REPLY" ' '`
		string=${REPLY#* }
		id2=`expr index "$string" ' '`
		idx=${string%% *}
		string=${string#* }
		if [ $id1 -eq 0 -o $id2 -eq 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		add_after $idx $string
	#supprime un dossier
	elif [ "${REPLY%% *}" == "delete" ]
	then
		id1=`expr index "$REPLY" ' '`
		idx=${REPLY#* }
		id2=`expr index "$idx" ' '`
		if [ $id1 -eq 0 -o $id2 -ne 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		delete $idx
	#déplace un dossier d'une ou plusieurs position vers le haut
	elif [ "${REPLY%% *}" == "moveup" ]
	then
		id1=`expr index "$REPLY" ' '`
		string=${REPLY#* }
		id2=`expr index "$string" ' '`
		idx=${string%% *}
		pos=${string#* }
		id3=`expr index "$pos" ' '`
		if [ $id1 -eq 0 -o $id2 -eq 0 -o $id3 -ne 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $idx -lt 0 -o $idx -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect index\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $((idx-$pos)) -lt 0 -o $((idx-$pos)) -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect diff value\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		moveup $idx $pos
	#déplace un dossier d'une ou plusieurs position vers le bas
	elif [ "${REPLY%% *}" == "movedown" ]
	then
		id1=`expr index "$REPLY" ' '`
		string=${REPLY#* }
		id2=`expr index "$string" ' '`
		idx=${string%% *}
		pos=${string#* }
		id3=`expr index "$pos" ' '`
		if [ $id1 -eq 0 -o $id2 -eq 0 -o $id3 -ne 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $idx -lt 0 -o $idx -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect index\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		if [ $((idx-$pos)) -lt 0 -o $((idx-$pos)) -ge $dirsize ]
		then
			echo -e "\e[1;31mERROR : incorrect diff value\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		movedown $idx $pos
	#remplace le nom d'un dossier
	elif [ "${REPLY%% *}" == "update" -o "${REPLY%% *}" == "replace" ]
	then
		id1=`expr index "$REPLY" ' '`
		string=${REPLY#* }
		id2=`expr index "$string" ' '`
		idx=${string%% *}
		string=${string#* }
		if [ $id1 -eq 0 -o $id2 -eq 0 ]
		then
			echo -e "\e[1;31mERROR : incorrect number of arguments\e[0m"
			echo '' #blank line skipped because of continue
			continue
		fi
		replace $idx $string
	#afficher l'aide
	elif [ "$REPLY" == "help" ]
	then
		my_help
	fi
	echo '' #blank line
done
