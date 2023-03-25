#!/bin/bash -f
 
 #
 # How to run
 # $B<+J,$N%G%#%l%/%H%j$K(BBacksetHistory $B$KBeF~$9$k%U%!%$%k$rMQ0U$9$k!#(B
 # '10back set'   $B$G%+%l%s%H$rJ]B8!#(B
 # '10back' or '10back (0 ~ 9)'$B!!$G9%$-$J%G%#%l%/%H%j$K(Bcd $B!#(B 
 # '10back set (0 ~ 9)'$B!!$G$=$N?t;z$K%+%l%s%H(Bset $B!#(B
 # 'q' or 'Ctrl-C'$B!!$G%k!<%W$rH4$1$k!#(B 
 # Shell $B$,(B Bash $B$G$J$$$HF0$+$J$$!#(B
 #
 
 BacksetHistory='/home/kato/99.storage/backset_history'   #$BJQ?t$KBeF~$9$k$H$-(B"~" $BEy$OE83+$5$l$J$$$?$a%U%k%Q%9$G=q$/I,MW$"$j!#(B
 DirOption=(`tail "$BacksetHistory"`) 
 ColorArray=('39' '51' '46' '154' '227' '208' '196' '207' '81' '154')


function ERROR1 () {
  echo "ERROR : too many arguments"
}


function ERROR2 () {
  echo "ERROR : Enter the number 0 ~ 9"
}


function ERROR3 () {
  echo "ERROR : Incorrect arguments"
}


function HistoryReplace () {
  originalDIR=${DirOption[ $(( ${#DirOption[*]} - $1 - 1 )) ]}
  newDIR=$(pwd)
  numline1=(`wc -l "$BacksetHistory"`)
  numline2=$(( $numline1 - $1 ))
  sed -i -e "${numline2}s:${originalDIR}:${newDIR}:g" "$BacksetHistory" 
  #$BCV49$7$?$$J8;zNs$K(B"/"$B$,F~$C$F$$$k$?$a(Bsed $B$N6h@Z$jJ8;z$r(B":"$B$K$7$?!#(B
  echo "______________________________________"
  echo
  echo " Current directory is set to Index $1 "
  echo "______________________________________"
  echo
}


 if (( $# > 2 )) ; then
   echo 
   ERROR1
   echo
 elif (( $# == 2 )) ; then 
   if [[ $1 == "set" && $2 =~ ^[0-9]+$ ]] ; then   #"[]" $B$h$j(B"[[]]" $B$N$[$&$,4JC1$K>r7o$r7k9g$G$-$k!#(B
     if (( $2 < 10 )) ; then
       HistoryReplace $2     
     else
       echo
       ERROR2
       echo
     fi
   elif [[ $1 == "ls" && $2 =~ ^[0-9]+$ ]] ; then
     if (( $2 < 10 )) ; then
       ls ${DirOption[ $(( ${#DirOption[*]} - $2 - 1 )) ]} 
     else
       echo 
       ERROR2
       echo
     fi
   else
     ERROR3
   fi
 elif (( $# == 1 )) ; then 
   if [[ $1 == "set" ]] ; then
     pwd >> "$BacksetHistory"
     echo "____________________________________"
     echo
     echo " Current directory is set to 10back "
     echo "____________________________________"
     echo
   elif [[ $1 =~ ^[0-9]+$ && $1 -lt 10 ]] ; then 
     cd ${DirOption[ $(( ${#DirOption[*]} - $1 - 1)) ]} ; ls
   else
     echo 
     ERROR2
     echo
   fi
 else
  
   echo '_________________________'
   echo
   echo ' choose directory number '
   echo '_________________________'
   echo
  
   for i in `seq 1 ${#DirOption[*]}`; do
       loop=$((${#DirOption[*]} - i))
       echo " -e \e[38;5;${ColorArray[$((i-1))]}m $((i-1)). \e[m" | echo -n $(cat)
       echo ${DirOption[$loop]}
   done
   echo
  
  
   while : ; do  #$BL58B%k!<%W!#$&$^$/$$$C$?$H$-$O(Bbreak $B$7$F!"$&$^$/$$$+$J$$$H$-$O(Berror $B$r$O$$$F$b$&(B1$B=d$9$k!#(B 
     read -a DIRNUM   # "-a" $B$OG[Ns$H$7$FFI$_9~$`%*%W%7%g%s(B
     if (( ${#DIRNUM[*]} > 2 )) ; then
       ERROR1
       continue    #continue $B$G%k!<%W$N=i$a$KLa$k!#(B
     elif (( ${#DIRNUM[*]} == 2 )) ; then
       if [[ ${DIRNUM[0]} == set && ${DIRNUM[1]} =~ ^[0-9]+$ ]] ; then   #$B$3$3$G$N>r7o$N=gHV$OL5$$G[Ns$NMWAG$K%"%/%;%9$5$;$J$$$?$a$KBg@Z!#(B
         if (( ${DIRNUM[1]} < 10 )) ; then   #"(())"$B$G$O?tCM$NHf3S$,$G$-$k!#(B"[[]]"$B$G$OJ8;zNsHf3S$K$J$k!#(B   #"&&" $B$O:8$K$"$k>r7o$,??$N;~$N$_1&$N>r7o$K?J$`!#(B
           HistoryReplace ${DIRNUM[1]}
           break
         else 
           ERROR2
           continue
         fi
       elif [[ ${DIRNUM[0]} == ls && ${DIRNUM[1]} =~ ^[0-9]+$ ]] ; then
         if (( ${DIRNUM[1]} < 10 )) ; then
           ls ${DirOption[ $(( ${#DirOption[*]} - DIRNUM[1] - 1 )) ]} 
         else
           ERROR2
           continue
         fi
       else
         ERROR2
         continue
       fi
     elif (( ${#DIRNUM[*]} == 1 )) ; then
       if [[ ${DIRNUM[0]} == q ]] ; then
         echo
         break
       elif [[ ${DIRNUM[0]} == set ]] ; then
         pwd >> "$BacksetHistory"
         echo "____________________________________"
         echo
         echo " Current directory is set to 10back "
         echo "____________________________________"
         echo
         break
       elif [[ ${DIRNUM[0]} =~ ^[0-9]+$ && ${DIRNUM[0]} -lt 10 ]] ; then   #"[[]]" $B$NCf$G$O(B"<" $B$,J8;zNsHf3S$K$J$k$?$a!"(B"-lt" $B$r;H$C$F?tCMHf3S$K$9$k!#(B
         cd ${DirOption[ $(( ${#DirOption[*]} - DIRNUM[0] - 1 )) ]} ; echo ; ls
         break
       else
         ERROR2
         continue
       fi
     else   #$BMWAG?t%<%m$N>l9g(B
       ERROR2
     fi
   done

 fi
 


