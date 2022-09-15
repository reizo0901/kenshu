#!/bin/bash

#実行ログ初期化
echo > /home/docker/code/result_guest.txt
#メッセージ出力用関数
msgoutput(){
    echo $1
    datetemp=`date "+%y/%m/%d %H:%M:%S"` 
    echo $datetemp $1 >> /home/docker/code/result_guest.txt
}

msgoutput "[Inf]コンテナ内設定スクリプトを実行します。"
#[sudo]のインストール
apt-get install -y sudo
if [ $? -eq 0 ]; then
    msgoutput "[Suc][sudo]のインストールに成功しました。"
else
    msgoutput "[Err][sudo]のインストールに失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

#[vim]のインストール
apt-get install -y vim
if [ $? -eq 0 ]; then
    msgoutput "[Suc][vim]のインストールに成功しました。"
else
    msgoutput "[Err][vim]のインストールに失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

#[sed]のインストール
apt-get install -y sudo
if [ $? -eq 0 ]; then
    msgoutput "[Suc][sed]のインストールに成功しました。"
else
    msgoutput "[Err][sed]のインストールに失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

#[visudo]のインストール
apt-get install -y sudo
if [ $? -eq 0 ]; then
    msgoutput "[Suc][visudo]のインストールに成功しました。"
else
    msgoutput "[Err][visudo]のインストールに失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

#ホストとのpermission問題を解決します。
msgoutput "ホストとのpermission問題を解決します。"
#ubuntuにはwheelが存在しないため作成します。
msgoutput "ubuntuにはwheelが存在しないため作成します。"
#[/etc/pam.d/su]を修正
goutput "[Inf]新しいauthを追記します。"
echo "auth sufficient pam_wheel.so trust group=wheel" >> /etc/pam.d/su 
if [ $? -eq 0 ]; then
    msgoutput "[Suc]追記に成功しました。"
else
    msgoutput "[Err]追記に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

msgoutput "[Inf]sudoersにwheelの設定を追記します。"
echo "%wheel ALL=(ALL) ALL" | EDITOR='tee -a' visudo > /dev/null
if [ $? -eq 0 ]; then
    msgoutput "[Suc]追記に成功しました。"
else
    msgoutput "[Err]追記に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi
addgroup --gid 1000 ec2-user
addgroup wheel
adduser --gid 1000 ec2-user
usermod -aG wheel ec2-user
#プロジェクトをec2-userで作成する。

su - ec2-user
msgoutput "cd /home/docker/code"
cd /home/docker/code/
msgoutput "[Inf]Defaultのプロジェクトを削除します。"
rm -rf /home/docker/code/app
if [ $? -eq 0 ]; then
    msgoutput "[Suc]プロジェクトの削除に成功しました。"
else
    msgoutput "[Err]プロジェクトの削除に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi
msgoutput "[Inf]プロジェクト[kenshu]を作成します。"
django-admin startproject kenshu
cd /home/docker/code/kenshu
msgoutput "[Inf]プロジェクト[kenshu]に[janken]アプリのディレクトリを作成します。"
python3 manage.py startapp janken
if [ $? -eq 0 ]; then
    msgoutput "[Suc][janken]アプリのディレクトリの作成に成功しました。"
else
    msgoutput "[Err][janken]アプリのディレクトリの作成に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

#kenshuプロジェクトの[settings.py]を修正
msgoutput "[Inf]settings.pyをsettings_tmp.pyにリネームします。"
mv /home/docker/code/kenshu/kenshu/settings.py /home/docker/code/kenshu/kenshu/settings_tmp.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]リネームが成功しました。"
else
    msgoutput "[Err]リネームが失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi
msgoutput "[Inf][kenshu]プロジェクトの[settngs.py]の修正"
msgoutput "[Inf]既存のALLOWED_HOSTSをコメントアウトします。"
sed -e "s/^ALLOWED_HOST/#ALLOWED_HOST/" /home/docker/code/kenshu/kenshu/settings_tmp.py > /home/docker/code/kenshu/kenshu/settings.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]コメントアウトに成功しました。"
else
    msgoutput "[Err]コメントアウトに失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi
msgoutput "[Inf]新しいALLOWED_HOSTSを追記します。"
echo "ALLOWED_HOSTS = ["\'"*"\'",]" >> /home/docker/code/kenshu/kenshu/settings.py
if [ $? -eq 0 ]; then
    msgoutput "[Suc]追記に成功しました。"
else
    msgoutput "[Err]追記に失敗しました。"
    msgoutput "[Inf]Script End!"
    exit
fi

msgoutput "[Inf]コンテナ内設定スクリプトを終了します。"
msgoutput "[Inf]Script End!"
