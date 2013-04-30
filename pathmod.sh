#!/bin/bash

## add :
## export BASHPID=$$
## to ~/.bashrc if bash < 4.0-alpha

DIR=`dirname ${BASH_SOURCE[0]}`
. $DIR/pathmod_functions.sh

#variables

#mode debug, 0 = off, 1 = on
#debug mode means it should be run as a separate process
#normal mode means it should be run as same process, with . path/file
DEBUG=1
#contenu de la ligne retournée par READ
REPLY=''
#code de retour de read (0 si normal, 1 si EOF)
ret=0

#afficher path
#echo -e "\e[31mPATH=\e[0m"
#echo $PATH

chk_call;

#sauvegarde l'ancienne valeur du séparateur de champ
IFS_OLD=$IFS
#séparateur de champ
IFS=':'
export IFS
#création d'un tableau
declare -a dirs=($PATH)
dirsize=${#dirs[@]}

#vérifie nombre de dossier : ERREUR si == 1 et PATH contient :
#chk_nb_dirs

#PATH
#dirs_show
#echo ''

#menu
. $DIR/pathmod_menu.sh

#sauvegarde
IFS=`echo -e " \t\n"`
IFS=:
PATH="${dirs[*]}" #only with [*]
export PATH

#restauration
IFS=$IFS_OLD
export IFS
#unsets
unset DIR dirs dirsize i id1 id2 idx ret string IFS_OLD DEBUG
