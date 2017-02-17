# pbl.zipのセットアップ手順の1を記載
# 
# 1. ベースバイナリの生成
#    - setup-base.sh
#    - 各インストーラやzipのダウンロードと展開
# 2. 設定ファイルの生成
#    - setup-conf.sh
#    - 設定ファイルの書き換えまで全てを記載
# 
# 動作環境：cygwin on win7 or later, x64
# できるだけimmutableに & 生成データを小さく
# 
# GUIから処理しないといけないコマンドがあるので注意
# *gui_xxx: GUIで処理する必要がある疑似コマンド


########################################
# init

export TMP=/d/tmp/
export PBL_HOME=/c/pbl/

unalias cp
mkdir -p $PBL_HOME

#########################################
# JDK

# GUIでのインストール時のJRE：不要
# GUIでのインストール時のパス：デフォルト（C:\Program Files\Java..）
cd $TMP
*gui_wget http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-windows-x64.exe
*gui_install jdk-8u121-windows.exe
cp -r /c/Program\ Files/Java/jdk1.8.0_121 $PBL_HOME
mv -f $PBL_HOME/jdk1.8.0_121 $PBL_HOME/java


#########################################
# Eclipse

cd $TMP
wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/4.6/pleiades-4.6.2-java-win-64bit_20161221.zip
unzip pleiades-4.6.2-java-win-64bit_20161221.zip
mv -f pleiades/eclipse $PBL_HOME/


#########################################
# Tomcat

cd $TMP
wget http://ftp.tsukuba.wide.ad.jp/software/apache/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.zip
unzip -o apache-tomcat-8.5.11.zip
mv apache-tomcat-8.5.11 $PBL_HOME/tomcat


########################################
# chrome

# GUIインストール先：$TMP
cd $TMP
*gui_wget https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/GoogleChromePortable64_46.0.2490.86_online.paf.exe/download
*gui_install GoogleChromePortable64_46.0.2490.86_online.paf.exe
mv -f GoogleChromePortable64 $PBL_HOME/chrome


########################################
# Mongodb

cd $TMP
wget http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-3.4.1.zip
unzip -o mongodb-win32-x86_64-2008plus-3.4.1.zip
mv -f mongodb-win32-x86_64-2008plus-3.4.1 $PBL_HOME/
mv $PBL_HOME/mongodb-win32-x86_64-2008plus-3.4.1 $PBL_HOME/mongodb


########################################
# teraterm

cd $TMP
gui_wget https://ja.osdn.net/frs/redir.php?m=iij&f=%2Fttssh2%2F66795%2Fteraterm-4.93.zip
unzip -o teraterm-4.93.zip
mv -f teraterm-4.93 $PBL_HOME
mv -f $PBL_HOME/teraterm-4.93 $PBL_HOME/teraterm


########################################
# cURL

cd $TMP
wget https://dl.uxnr.de/build/curl/curl_winssl_msys2_mingw64_stc/curl-7.52.1/curl-7.52.1.zip
unzip -o curl-7.52.1.zip
mkdir -p $PBL_HOME/curl
mv -f src/curl.exe $PBL_HOME/curl/


########################################
# RLogin

cd $TMP
wget http://nanno.dip.jp/softlib/program/rlogin_x64.zip
unzip -o rlogin_x64.zip
mkdir -p $PBL_HOME/rlogin/
mv -f RLogin.exe $PBL_HOME/rlogin/


########################################
# cleanup
cleanup_tomcat() {
  rm -rf $PBL_HOME/tomcat/logs/*
  rm -rf $PBL_HOME/tomcat/temp/*
  rm -rf $PBL_HOME/tomcat/work/*
  rm -rf $PBL_HOME/tomcat/conf/Catalina
  find $PBL_HOME/tomcat/webapps -maxdepth 1 -mindepth 1 -type d | egrep -v "docs|examples|host-manager|manager|ROOT" | xargs rm -rf
}
cleanup_mongodb() {
  rm -rf $PBL_HOME/mongodb/data/*
}
cleanup_eclipse() {
  rm -rf $PBL_HOME/eclipse/configuration/*.log
  rm -rf $PBL_HOME/eclipse/p2/org.eclipse.equinox.p2.repository
  find $PBL_HOME/eclipse/configuration -maxdepth 1 -mindepth 1 -type d | egrep -v ".settings|org.eclipse.equinox.simpleconfigurator|org.eclipse.update" | xargs rm -rf
}
cleanup() {
  cleanup_mongodb
  cleanup_tomcat
  cleanup_eclipse
}

cleanup

