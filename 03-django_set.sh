#!/bin/bash

#実行ログ初期化
echo > /home/docker/code/result_django.txt
#メッセージ出力用関数
msgoutput(){
    echo $1
    datetemp=`date "+%y/%m/%d %H:%M:%S"` 
    echo $datetemp $1 >> /home/docker/code/result_django.txt
}

msgoutput "[Inf]Django設定スクリプトを実行します。"
msgoutput "cd /home/docker/code"
cd /home/docker/code/
msgoutput "[Inf]プロジェクト[kenshu]を作成します。"
django-admin startproject kenshu
if [ $? -eq 0 ]; then
    msgoutput "[Suc]プロジェクト[kenshu]の作成に成功しました。"
else
    msgoutput "[Err]プロジェクト[kenshu]の作成に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit 1
fi
cd /home/docker/code/kenshu
msgoutput "[Inf]プロジェクト[kenshu]に[app]アプリのディレクトリを作成します。"
python3 manage.py startapp app
if [ $? -eq 0 ]; then
    msgoutput "[Suc][app]アプリのディレクトリの作成に成功しました。"
else
    msgoutput "[Err][app]アプリのディレクトリの作成に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit 1
fi
#staticディレクトリ作成
mkdir static
mkdir media
#kenshuプロジェクトの[settings.py]を修正
msgoutput "[Inf]settings.pyをsettings_tmp.pyにリネームします。"
mv /home/docker/code/kenshu/kenshu/settings.py /home/docker/code/kenshu/kenshu/settings_tmp.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]リネームが成功しました。"
else
    msgoutput "[Err]リネームが失敗しました。"
    msgoutput "[Inf]Script End!"
    exit 1
fi
msgoutput "[Inf][kenshu]プロジェクトの[settngs.py]の修正"
msgoutput "[Inf]既存のALLOWED_HOSTSをコメントアウト、日本時刻設定、日本語表示設定をします。"
sed -e "s/^ALLOWED_HOST.*$/ALLOWED_HOSTS = ["\'"*"\'",]/" -e "s/UTC/Asia\/Tokyo/" -e "s/en-us/ja/" /home/docker/code/kenshu/kenshu/settings_tmp.py > /home/docker/code/kenshu/kenshu/settings.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]コメントアウト、日本時刻設定、日本語表示設定に成功しました。"
else
    msgoutput "[Err]コメントアウト、日本時刻設定、日本語表示設定に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit 1
fi
msgoutput "[Inf]新しいSTATIC_ROOTを追記します。"
echo "STATIC_ROOT = str(os.path.join(BASE_DIR,'static'))" >> /home/docker/code/kenshu/kenshu/settings.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]追記に成功しました。"
else
    msgoutput "[Err]追記に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit 1
fi
#staticディレクトリの統合
cd /home/docker/code/kenshu
python3 manage.py collectstatic << "EOF"
yes
EOF

msgoutput "[Inf]Django設定スクリプト終了します。"
#実行ログ改行挿入
echo > /home/docker/code/result_django.txt
exit 0
