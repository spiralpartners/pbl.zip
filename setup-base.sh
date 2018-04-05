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

export VERSION="base ver 0.2"

export TMP=/d/tmp/pbl/
export PBL_HOME=/c/pbl/

unalias cp
mkdir -p $PBL_HOME

#########################################
# version
echo $VERSION > $PBL_HOME/version.txt

#########################################
# JDK

# GUIでのインストール時のJRE：不要
# GUIでのインストール時のパス：デフォルト（C:\Program Files\Java..）
cd $TMP
*gui_wget http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-windows-x64.exe
*gui_install jdk-8u162-windows-x64.exe
cp -r /c/Program\ Files/Java/jdk1.8.0_162 $PBL_HOME/
mv -f $PBL_HOME/jdk1.8.0_162 $PBL_HOME/java


#########################################
# Eclipse

cd $TMP
*gui_wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/oxygen/3/eclipse-java-oxygen-3-win32-x86_64.zip
unzip eclipse-java-oxygen-3-win32-x86_64.zip
cp -r eclipse $PBL_HOME/eclipse

# Pleiades (日本語化)
cd $TMP
wget http://svn.osdn.jp/svnroot/mergedoc/trunk/Pleiades/build/pleiades.zip
unzip pleiades-win.zip -d pleiades/
cp -r pleiades/* $PBL_HOME/eclipse/
rm -rf $PBL_HOME/eclipse/setup/
rm -rf $PBL_HOME/eclipse/setup.exe.lnk

#########################################
# Tomcat

cd $TMP
wget http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.zip
unzip -o apache-tomcat-8.5.29.zip
cp -r apache-tomcat-8.5.29 $PBL_HOME/
mv $PBL_HOME/apache-tomcat-8.5.29 $PBL_HOME/tomcat


########################################
# Mongodb

cd $TMP
wget http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.4.14.zip
unzip mongodb-win32-x86_64-2008plus-ssl-v3.4-latest.zip
cp -r mongodb-win32-x86_64-2008plus-ssl-3.4.14-29-gb27f7bc476 $PBL_HOME/
mv $PBL_HOME/mongodb-win32-x86_64-2008plus-ssl-3.4.14-29-gb27f7bc476 $PBL_HOME/mongodb


########################################
# RLogin

cd $TMP
wget http://nanno.dip.jp/softlib/program/rlogin_x64.zip
unzip -o rlogin_x64.zip
mkdir -p $PBL_HOME/rlogin/
mv -f RLogin.exe $PBL_HOME/rlogin/


########################################
# Git Bash

cd $TMP
*gui_wget https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/PortableGit-2.16.2-64-bit.7z.exe
*gui_install PortableGit-2.16.2-64-bit.7z.exe
cp -r PortableGit $PBL_HOME/
mv $PBL_HOME/PortableGit $PBL_HOME/git-bash

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

