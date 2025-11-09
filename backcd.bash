#!/bin/bash -f

#
# How to run
# 自分のディレクトリにBacksetHistory に代入するファイルを用意する。
# '10back set'   でカレントを保存。
# '10back' or '10back (0 ~ 9)'　で好きなディレクトリにcd 。
# '10back set (0 ~ 9)'　でその数字にカレントset 。
# 'q' or 'Ctrl-C'　でループを抜ける。
# Shell が Bash でないと動かない。
#

BacksetHistory='$HOME/00.repos/c.cli-tools/backcd.bash/nogit/backset_history' #変数に代入するとき"~" 等は展開されないためフルパスで書く必要あり。
DirOption=($(tail "$BacksetHistory"))
ColorArray=('39' '51' '46' '154' '227' '208' '196' '207' '81' '154')

function ERROR1() {
    echo "ERROR : too many arguments"
}

function ERROR2() {
    echo "ERROR : Enter the number 0 ~ 9"
}

function ERROR3() {
    echo "ERROR : Incorrect arguments"
}

function HistoryReplace() {
    originalDIR=${DirOption[$((${#DirOption[*]} - $1 - 1))]}
    newDIR=$(pwd)
    numline1=($(wc -l "$BacksetHistory"))
    numline2=$(($numline1 - $1))
    sed -i -e "${numline2}s:${originalDIR}:${newDIR}:g" "$BacksetHistory"
    #置換したい文字列に"/"が入っているためsed の区切り文字を":"にした。
    echo "______________________________________"
    echo
    echo " Current directory is set to Index $1 "
    echo "______________________________________"
    echo
}

if (($# > 2)); then
    echo
    ERROR1
    echo
elif (($# == 2)); then
    if [[ $1 == "set" && $2 =~ ^[0-9]+$ ]]; then #"[]" より"[[]]" のほうが簡単に条件を結合できる。
        if (($2 < 10)); then
            HistoryReplace $2
        else
            echo
            ERROR2
            echo
        fi
    elif [[ $1 == "ls" && $2 =~ ^[0-9]+$ ]]; then
        if (($2 < 10)); then
            ls ${DirOption[$((${#DirOption[*]} - $2 - 1))]}
        else
            echo
            ERROR2
            echo
        fi
    else
        ERROR3
    fi
elif (($# == 1)); then
    if [[ $1 == "set" ]]; then
        pwd >>"$BacksetHistory"
        echo "____________________________________"
        echo
        echo " Current directory is set to 10back "
        echo "____________________________________"
        echo
    elif [[ $1 =~ ^[0-9]+$ && $1 -lt 10 ]]; then
        cd ${DirOption[$((${#DirOption[*]} - $1 - 1))]}
        ls
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

    for i in $(seq 1 ${#DirOption[*]}); do
        loop=$((${#DirOption[*]} - i))
        echo " -e \e[38;5;${ColorArray[$((i - 1))]}m $((i - 1)). \e[m" | echo -n $(cat)
        echo ${DirOption[$loop]}
    done
    echo

    while :; do        #無限ループ。うまくいったときはbreak して、うまくいかないときはerror をはいてもう1巡する。
        read -a DIRNUM # "-a" は配列として読み込むオプション
        if ((${#DIRNUM[*]} > 2)); then
            ERROR1
            continue #continue でループの初めに戻る。
        elif ((${#DIRNUM[*]} == 2)); then
            if [[ ${DIRNUM[0]} == set && ${DIRNUM[1]} =~ ^[0-9]+$ ]]; then #ここでの条件の順番は無い配列の要素にアクセスさせないために大切。
                if ((${DIRNUM[1]} < 10)); then                             #"(())"では数値の比較ができる。"[[]]"では文字列比較になる。   #"&&" は左にある条件が真の時のみ右の条件に進む。
                    HistoryReplace ${DIRNUM[1]}
                    break
                else
                    ERROR2
                    continue
                fi
            elif [[ ${DIRNUM[0]} == ls && ${DIRNUM[1]} =~ ^[0-9]+$ ]]; then
                if ((${DIRNUM[1]} < 10)); then
                    ls ${DirOption[$((${#DirOption[*]} - DIRNUM[1] - 1))]}
                else
                    ERROR2
                    continue
                fi
            else
                ERROR2
                continue
            fi
        elif ((${#DIRNUM[*]} == 1)); then
            if [[ ${DIRNUM[0]} == q ]]; then
                echo
                break
            elif [[ ${DIRNUM[0]} == set ]]; then
                pwd >>"$BacksetHistory"
                echo "____________________________________"
                echo
                echo " Current directory is set to 10back "
                echo "____________________________________"
                echo
                break
            elif [[ ${DIRNUM[0]} =~ ^[0-9]+$ && ${DIRNUM[0]} -lt 10 ]]; then #"[[]]" の中では"<" が文字列比較になるため、"-lt" を使って数値比較にする。
                cd ${DirOption[$((${#DirOption[*]} - DIRNUM[0] - 1))]}
                echo
                ls
                break
            else
                ERROR2
                continue
            fi
        else #要素数ゼロの場合
            ERROR2
        fi
    done

fi
