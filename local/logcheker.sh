#!/bin/bash
#検出対象ログファイル
TARGET_LOG="./result_guest.txt"

#検出文字列
_error_conditions="script end"

#ログファイルを監視する関数
hit_action() {
    while read i 
    do
        echo $i | grep -q "${_error_conditions}"
        if [ $? = "0" ];then
            #アクション
        fi
    done
}

#main
if [ ! -f ${TARGET_LOG} ]; then
    touch ${TARGET_LOG}
fi

tail -n 0 --follow=name --retry $TARGETLOG | hit_action
taile
