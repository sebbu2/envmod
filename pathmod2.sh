#!/bin/bash

## add :
## export BASHPID=$$
## to ~/.bashrc if bash < 4.0-alpha

#declare -r DIR=`dirname ${BASH_SOURCE[0]}`
DIR=`dirname ${BASH_SOURCE[0]}`
. $DIR/pathmod_functions.sh

#variables

#mode debug, 0 = off, 1 = on
#debug mode means it should be run as a separate process
#normal mode means it should be run as same process, with . path/file
#declare -r DEBUG=1
DEBUG=1
#contenu de la ligne retournée par READ
REPLY=''
#code de retour de read (0 si normal, 1 si EOF)
ret=0

#afficher path
#echo -e "\e[31mPATH=\e[0m"
#echo $PATH

chk_call;

test=
#usage test
chk_usage $@
test=$?
#declare -r VAR
#echo '$#='$#
shift "${test:-0}"
#echo test=$test
unset test
#echo "VAR=$VAR"
if [ $# -le 0 ]
then
	echo "Usage:"
	echo -e "\t$0 -help\t pour l'aide"
fi
#echo '$#='$#

if [ $# -le 0 ]
then
	quitter
fi

#sauvegarde l'ancienne valeur du séparateur de champ
IFS_OLD=$IFS
#séparateur de champ
IFS=':'
export IFS
#création d'un tableau
declare -a dirs=(${!VAR})
dirsize=${#dirs[@]}

#vérifie nombre de dossier : ERREUR si == 1 et PATH contient :
#chk_nb_dirs

#PATH
#dirs_show
#echo ''

#actions
. $DIR/pathmod_actions.sh

#sauvegarde
IFS=`echo -e " \t\n"`
IFS=:
#PATH="${dirs[*]}" #only with [*]
#export PATH
eval $VAR="${dirs[*]}"
export ${VAR}

#restauration
IFS=$IFS_OLD
export IFS
#unsets
unset dirs dirsize i id1 id2 idx ret string IFS_OLD
unset DIR DEBUG
