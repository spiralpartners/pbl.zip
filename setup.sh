# pbl.zipのセットアップ手順
# 各インストーラやzipのダウンロードから，展開，設定ファイルの書き換えまで全てを記載
# 
# 動作環境：cygwin on win7 or later, x64
# 
# できるだけimmutableに & 生成データを小さく
# 
# GUIから処理しないといけないコマンドがあるので注意
# *gui_xxx: GUIで処理する必要がある疑似コマンド


########################################
# setup

export TMP=/d/tmp/
export PBL_HOME=/c/pbl/

unalias cp
mkdir -p $PBL_HOME

# 対象ファイルのorigバックアップを生成
retain(){
  if [ -f "$*.orig" ] then
    # origあるなら何もしない
  else
    if [ ! -f "$*" ]; then
      # 元ファイルがなければ空orig
      touch "$*.orig"
    else
      # 元ファイルあるならコピーorig
      cp -n "$*" "$*.orig"
    fi
  fi
}

# 対象ファイルをorigバックアップから復元
restore() {
  cp -f "$*.orig" "$*"
}

# 上2つを同時に実行
retain_restore() {
  retain $*
  restore $*
}

#########################################
# JDK

# インストール
# - GUIでのインストール時のJRE：不要
# - GUIでのインストール時のパス：デフォルト（C:\Program Files\Java..）
cd $TMP
*gui_wget http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-windows-x64.exe
*gui_install jdk-8u121-windows.exe
cp -r /c/Program\ Files/Java/jdk1.8.0_121 $PBL_HOME
mv -f $PBL_HOME/jdk1.8.0_121 $PBL_HOME/java


#########################################
# Eclipse

# インストール
cd $TMP
wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/4.6/pleiades-4.6.2-java-win-64bit_20161221.zip
unzip pleiades-4.6.2-java-win-64bit_20161221.zip
mv -f pleiades/eclipse $PBL_HOME/

# Javaのパスを$PBL_HOME/javaに固定
cd $PBL_HOME/
retain_restore eclipse/eclipse.ini
_PATH=$(cygpath -w $PBL_HOME | sed 's|\\|/|g')
sed -i 's|\(-product\)|-vm\n'$_PATH'java/bin/javaw.exe\n\1|' eclipse/eclipse.ini

# デフォルトワークスペースを$PBL_HOME/workspaceに固定
cd $PBL_HOME/
retain_restore eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
_PATH=$(echo $PBL_HOME'/workspace' | xargs cygpath -w | sed 's|\\|\\\\\\\\|g' | sed 's|:|\\\\:|')
sed -i 's|^SHOW_WORKSPACE_SELECTION_DIALOG=true|SHOW_WORKSPACE_SELECTION_DIALOG=false|' eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
sed -i 's|^RECENT_WORKSPACES=.*|RECENT_WORKSPACES='"${_PATH}"'|' eclipse/configuration/.settings/org.eclipse.ui.ide.prefs

# eclipseのUI設定
# - デフォルト文字コードをutf8
# - フォントをconsolas
# - D&D編集を無効化
# - スペルチェックの無効化
# - 終了時に確認しない
# - 常にこのパースペクティブを使う
# - 起動時のようこそ画面をオフ
# - 起動時のプラグインを全てオフ
# - パースペクティブレイアウトの全体情報
# - xmlを開く際のデフォルトエディタを設計ではなくソースに
cd $PBL_HOME
rm -rf workspace
mkdir -p workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/
mkdir -p workspace/.metadata/.plugins/org.eclipse.e4.workbench/
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.core.resources.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.wst.xml.ui.prefs
retain_restore $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
cd $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/
echo -e 'eclipse.preferences.version=1\nencoding=utf-8\nversion=1' > org.eclipse.core.resources.prefs
echo -e 'eclipse.preferences.version=1\noverviewRuler_migration=migrated_3.1\nspellingEnabled=false\ntextDragAndDropEnabled=false' > org.eclipse.ui.editors.prefs
echo -e 'EXIT_PROMPT_ON_CLOSE_LAST_WINDOW=false\nIDE_ENCODINGS_PREFERENCE=utf-8\nPROBLEMS_FILTERS_MIGRATE=true\neclipse.preferences.version=1\nplatformState=1485945983339\nquickStart=false\ntipsAndTricks=true' > org.eclipse.ui.ide.prefs
echo -e 'eclipse.preferences.version=1\nshowIntro=false' > org.eclipse.ui.prefs
echo -e 'eclipse.preferences.version=1\nPLUGINS_NOT_ACTIVATED_ON_STARTUP=com.xored.glance.ui;de.loskutov.anyedit.AnyEditTools;junit.extensions.eclipse.quick;junit.extensions.eclipse.quick.mock;net.sf.eclipsecs.ui;org.eclipse.buildship.stsmigration;org.eclipse.cft.server.verify.ui;org.eclipse.epp.logging.aeri.ide;org.eclipse.epp.mpc.ui;org.eclipse.equinox.p2.ui.sdk.scheduler;org.eclipse.jst.j2ee.webservice.ui;org.eclipse.m2e.discovery;org.eclipse.mylyn.builds.ui;org.eclipse.mylyn.tasks.ui;org.eclipse.mylyn.team.ui;org.eclipse.rse.ui;org.eclipse.swtbot.eclipse.ui;org.eclipse.swtbot.generator;org.eclipse.team.svn.ui.startup;org.eclipse.ui.monitoring;org.sf.feeling.decompiler;' > org.eclipse.ui.workbench.prefs
echo -e 'REMOTE_COMMANDS_VIEW_FONT=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\nfindBugsEclipsePlugin.consoleFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.compare.contentmergeviewer.TextMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.debug.ui.DetailPaneFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.debug.ui.MemoryViewTableFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.debug.ui.consoleFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.egit.ui.CommitMessageEditorFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.egit.ui.CommitMessageFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.egit.ui.DiffHeadlineFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.jdt.internal.ui.compare.JavaMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.jdt.internal.ui.compare.PropertiesFileMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.jdt.ui.PropertiesFileEditor.textfont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.jdt.ui.editors.textfont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.jface.textfont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.mylyn.wikitext.ui.presentation.textFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.pde.internal.ui.compare.ManifestContentMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.pde.internal.ui.compare.PluginContentMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.recommenders.snipmatch.rcp.searchTextFont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.wst.jsdt.internal.ui.compare.JavaMergeViewer=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.wst.jsdt.ui.editors.textfont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\norg.eclipse.wst.sse.ui.textfont=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\npreference.console.font=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;\nterminal.views.view.font.definition=1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;' >> org.eclipse.ui.workbench.prefs
echo -e 'eclipse.preferences.version=1\norg.eclipse.wst.xml.ui.internal.tabletree.XMLMultiPageEditorPart.lastActivePage=1' > org.eclipse.wst.xml.ui.prefs
wget http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/workbench.xmi -O $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
# --- https://github.com/spiralpartners/pbl.zipにも同じ内容のファイルあり
cd $PBL_HOME


#########################################
# Tomcat

# インストール
cd $TMP
wget http://ftp.tsukuba.wide.ad.jp/software/apache/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.zip
unzip -o apache-tomcat-8.5.11.zip
mv apache-tomcat-8.5.11 $PBL_HOME/tomcat

# 実行時のJavaパスを$PBL_HOME/javaに固定
cd $PBL_HOME
retain_restore tomcat/bin/startup.bat
_PATH=$(echo $PBL_HOME'/java' | xargs cygpath -w | sed 's|\\|\\\\|g')
sed -b -i 's|setlocal|setlocal\n\nrem [pbl.zip] Fix JDK paths\nset JAVA_HOME='$_PATH'\nset JRE_HOME='$_PATH'|' tomcat/bin/startup.bat

# anti*Locking
# - pending

########################################
# chrome

# インストール
# - GUIインストール先：$TMP
cd $TMP
*gui_wget https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/GoogleChromePortable64_46.0.2490.86_online.paf.exe/download
*gui_install GoogleChromePortable64_46.0.2490.86_online.paf.exe
mv -f GoogleChromePortable64 $PBL_HOME/chrome

# 設定ファイルの自動生成
cd $PBL_HOME
rm -rf chrome/Data/profile
cygstart $PBL_HOME/chrome/GoogleChromePortable.exe
sleep 3
*gui_exit $PBL_HOME/chrome/GoogleChromePortable.exe

# 母国語以外での翻訳モードを無効化（ドロップダウン描画が開発時に邪魔する）
cd $PBL_HOME
retain_restore chrome/Data/profile/Default/Preferences
sed -i 's|\("translate_blocked_languages":[^/]*,\)|"translate":{"enabled":false},\1|' chrome/Data/profile/Default/Preferences


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
retain_restore mongodb/mongod.conf
retain_restore mongodb/bin/mongod.bat
_PATH=$(cygpath -w $PBL_HOME)
echo -e 'dbpath = '$_PATH'mongodb\\data\n#cpu    = true\n#port   = 10000' > mongodb/mongod.conf
echo -e $_PATH'mongodb\\bin\\mongod.exe --config '$_PATH'mongodb\\mongod.conf' > mongodb/bin/mongod.bat


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


#########################################
# 変更を加えた設定ファイルの差分抽出


export DELTA=/d/tmp/delta/

extract_delta() {
  TO=$(echo "$*" | sed "s|$PBL_HOME|$DELTA|" | xargs dirname)
  mkdir -p $TO
  cp -f "$*" $TO
  cp -f "$*.orig" $TO
}

rm -rf $DELTA
extract_delta $PBL_HOME/eclipse/eclipse.ini
extract_delta $PBL_HOME/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
extract_delta $PBL_HOME/tomcat/bin/startup.bat
extract_delta $PBL_HOME/mongodb/mongod.conf
extract_delta $PBL_HOME/mongodb/bin/mongod.bat
extract_delta $PBL_HOME/chrome/Data/profile/Default/Preferences
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.core.resources.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.ide.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.wst.xml.ui.prefs
extract_delta $PBL_HOME/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi

