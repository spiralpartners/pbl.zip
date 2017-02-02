# 注意
# gui_xxx: GUIで処理する必要がある疑似コマンド

unalias cp

# 
export TMP=/d/tmp/
export PBL_HOME=/c/pbl/

# setup
mkdir -p $PBL_HOME


#########################################
# JDK

# インストール
cd $TMP
gui_wget http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-windows-x64.exe
gui_install jdk-8u121-windows.exe
# -- インストール時のJRE：不要
# -- インストールパス：デフォルト（C:\Program Files\Java..）で良い

cp -r /c/Program\ Files/Java/jdk1.8.0_121 $PBL_HOME
mv -f $PBL_HOME/jdk1.8.0_121 $PBL_HOME/java



#########################################
# Eclipse

# インストール
cd $TMP
wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/4.6/pleiades-4.6.2-java-win-64bit_20161221.zip
unzip pleiades-4.6.2-java-win-64bit_20161221.zip
mv -f pleiades/eclipse $PBL_HOME/


mkdir $PBL_HOME/workspace

# Javaのパスを$PBL_HOME/javaに固定
cp -n eclipse/eclipse.ini eclipse/eclipse.ini.orig
cp -f eclipse/eclipse.ini.orig eclipse/eclipse.ini
if ! grep -Fq '^-vmargs$' eclipse/eclipse.ini
then
  _PATH=$(cygpath -w $PBL_HOME | sed 's|\\|/|g')
  sed -i 's|\(-product\)|-vm\n'"${_PATH}"'java/bin/javaw.exe\n\1|' eclipse/eclipse.ini
fi

# デフォルトワークスペースを$PBL_HOME/workspaceに固定
cp -n eclipse/configuration/.settings/org.eclipse.ui.ide.prefs eclipse/configuration/.settings/org.eclipse.ui.ide.prefs.orig
cp -f eclipse/configuration/.settings/org.eclipse.ui.ide.prefs.orig eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
_PATH=$(echo $PBL_HOME'/workspace' | xargs cygpath -w | sed 's|\\|\\\\\\\\|g' | sed 's|:|\\\\:|')
sed -i 's|^SHOW_WORKSPACE_SELECTION_DIALOG=true|SHOW_WORKSPACE_SELECTION_DIALOG=false|' eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
sed -i 's|^RECENT_WORKSPACES=.*|RECENT_WORKSPACES='"${_PATH}"'|' eclipse/configuration/.settings/org.eclipse.ui.ide.prefs


# ようこそ
workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi

### utf-8
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.core.resources.prefs
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs

### font
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs

### D&D
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs

### spel
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs

### exit confirm
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs

### 常にパースペクティブ
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs

### パースペクティブレイアウト
workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi

### ようこそ
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.prefs

### 起動時のプラグイン
workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs

#########################################
# Tomcat

# インストール
cd $TMP
wget http://ftp.tsukuba.wide.ad.jp/software/apache/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.zip
unzip -o apache-tomcat-8.5.11.zip
mv apache-tomcat-8.5.11 $PBL_HOME/tomcat


# Javaのパスを$PBL_HOME/javaに固定
cd $PBL_HOME
cp -n tomcat/bin/startup.bat tomcat/bin/startup.bat.orig
cp -f tomcat/bin/startup.bat.orig tomcat/bin/startup.bat
if ! grep -Fq 'rem \[pbl.zip\] Fix JDK paths' tomcat/bin/startup.bat
then
  _PATH=$(echo $PBL_HOME'/java' | xargs cygpath -w | sed 's|\\|\\\\|g')
  _LN=$(grep -n 'setlocal' tomcat/bin/startup.bat --color=never | cut -d":" -f1)
  sed -i "${_LN}"'s|setlocal|setlocal\n\nrem [pbl.zip] Fix JDK paths\nset JAVA_HOME='"${_PATH}"'\nset JRE_HOME='"${_PATH}|" tomcat/bin/startup.bat
  unix2dos tomcat/bin/startup.bat
fi

########################################


########################################
# chrome

cd $TMP
gui_wget https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/GoogleChromePortable64_46.0.2490.86_online.paf.exe/download
gui_install GoogleChromePortable64_46.0.2490.86_online.paf.exe
# -- Install to $TMP directory from GUI.
mv -f GoogleChromePortable64 $PBL_HOME/chrome

# 母国語以外での翻訳モードを無効化（ドロップダウン描画が開発時に邪魔する）
cd $PBL_HOME
gui_exec $PBL_HOME/chrome/GoogleChromePortable.exe
cp -n chrome/Data/profile/Default/Preferences chrome/Data/profile/Default/Preferences.orig
cp -f chrome/Data/profile/Default/Preferences.orig chrome/Data/profile/Default/Preferences
if ! grep -Fq '"translate":' chrome/Data/profile/Default/Preferences
then
  sed -i 's|\("translate_blocked_languages"[^/]*,\)|"translate":{"enabled":false},\1|' chrome/Data/profile/Default/Preferences
fi

########################################
# Mongodb

# インストール
cd $TMP
wget http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-3.4.1.zip
unzip -o mongodb-win32-x86_64-2008plus-3.4.1.zip
mv -f mongodb-win32-x86_64-2008plus-3.4.1 $PBL_HOME/
mv $PBL_HOME/mongodb-win32-x86_64-2008plus-3.4.1 $PBL_HOME/mongodb

# 起動時の設定（confの生成とそれを使って起動するbatの生成）
cd $PBL_HOME
mkdir -p mongodb/data
_PATH=$(cygpath -w $PBL_HOME)
echo -e "dbpath = C:\pbl\mongodb\data\n#cpu    = true\n#port   = 10000" > mongodb/mongod.conf
echo "${_PATH}mongodb\bin\mongod.exe --config ${_PATH}mongodb\mongod.conf" > mongodb/bin/mongod.bat


########################################
# teraterm

cd $TMP
gui_wget https://ja.osdn.net/frs/redir.php?m=iij&f=%2Fttssh2%2F66795%2Fteraterm-4.93.exe
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


################################################################################
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

cleanup_mongodb
cleanup_tomcat

#########################################
# ...........................

backup() {
  cp -n "$*" "$*.orig"
}



export DIFF=/d/tmp/diff/

extract_delta() {
  TO=$(echo "$*" | sed "s|$PBL_HOME|$DIFF|")
  echo $TO | sed "s|^\(.*/\).*|\1|" | xargs mkdir -p
  cp -f "$*" $TO
}
extract_delta $PBL_HOME/tomcat/bin/startup.bat
extract_delta $PBL_HOME/mongodb/mongod.conf
extract_delta $PBL_HOME/mongodb/bin/mongod.bat
extract_delta $PBL_HOME/chrome/Data/profile/Default/Preferences



mkdir -p $DIFF/chrome/Data/profile/Default/ && cp $PBL_HOME/chrome/Data/profile/Default/Preferences.orig "$_"
mkdir -p $DIFF/tomcat/bin/ && cp $PBL_HOME/tomcat/bin/startup.bat.orig "$_"






extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.core.resources.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
