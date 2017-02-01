# ����
# gui_xxx: GUI�ŏ�������K�v������^���R�}���h

unalias cp

# 
export TMP=/d/tmp/
export PBL_HOME=/c/pbl/
export PBL_HOME_WIN=`cygpath -w $PBL_HOME`


# setup
mkdir $PBL_HOME


#########################################
# JDK
cd $TMP

# �C���X�g�[��
gui_wget http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-windows-x64.exe
gui_install jdk-8u121-windows.exe
# -- �C���X�g�[������JRE�F�s�v
# -- �C���X�g�[���p�X�F�f�t�H���g�iC:\Program Files\Java..�j�ŗǂ�

cp -r /c/Program\ Files/Java/jdk1.8.0_121 $PBL_HOME
mv -f $PBL_HOME/jdk1.8.0_121 $PBL_HOME/java



#########################################
# Eclipse



#########################################
# Tomcat

# �C���X�g�[��
cd $TMP
wget http://ftp.tsukuba.wide.ad.jp/software/apache/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.zip
unzip -o apache-tomcat-8.5.11.zip
mv apache-tomcat-8.5.11 $PBL_HOME/tomcat


# JAVA�̃p�X��$PBL_HOME�ɌŒ�
cd $PBL_HOME
cp -n tomcat/bin/startup.bat tomcat/bin/startup.bat.orig
cp -f tomcat/bin/startup.bat.orig tomcat/bin/startup.bat
if ! grep -Fq "rem [pbl.zip] Fix JDK paths" tomcat/bin/startup.bat
then
  _PATH=$(echo $PBL_HOME'/java' | xargs cygpath -w | sed 's|\\|\\\\|g')
  _LN=$(grep -n 'setlocal' tomcat/bin/startup.bat --color=never | cut -d":" -f1)
  sed -i "${_LN}"'s|setlocal|setlocal\n\nrem [pbl.zip] Fix JDK paths\nset JAVA_HOME='"${_PATH}"'\nset JRE_HOME='"${_PATH}|" tomcat/bin/startup.bat
  unix2dos tomcat/bin/startup.bat
fi

########################################
# chrome

cd $TMP
gui_wget https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/GoogleChromePortable64_46.0.2490.86_online.paf.exe/download
gui_install GoogleChromePortable64_46.0.2490.86_online.paf.exe
# -- Install to $TMP directory from GUI.
mv -f GoogleChromePortable64 $PBL_HOME/chrome

# �ꍑ��ȊO�ł̖|�󃂁[�h�𖳌����i�h���b�v�_�E���`�悪�J�����Ɏז�����j
gui_exec $PBL_HOME/chrome/GoogleChromePortable.exe
cd $PBL_HOME
cp -n chrome/Data/profile/Default/Preferences chrome/Data/profile/Default/Preferences.orig
cp -f chrome/Data/profile/Default/Preferences.orig chrome/Data/profile/Default/Preferences
if ! grep -Fq '"translate":' chrome/Data/profile/Default/Preferences
then
  sed -i 's|\("translate_blocked_languages"[^/]*,\)|"translate":{"enabled":false},\1|' chrome/Data/profile/Default/Preferences
fi

########################################
# Mongodb

# �C���X�g�[��
cd $TMP
wget http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-3.4.1.zip
unzip -o mongodb-win32-x86_64-2008plus-3.4.1.zip
mv -f mongodb-win32-x86_64-2008plus-3.4.1 $PBL_HOME/mongodb

# �N�����̐ݒ�iconf�̐����Ƃ�����g���ċN������bat�̐����j
cd $PBL_HOME
mkdir mongodb/data
_PATH=$(cygpath -w $PBL_HOME)
echo -e "dbpath = C:\pbl\mongodb\data\n#cpu    = true\n#port   = 10000" > mongodb/mongod.conf
echo "${_PATH}mongodb\bin\mongod.exe --config ${_PATH}mongodb\mongod.conf" > mongodb/bin/mongod.bat


########################################
# RLogin

cd $TMP
wget http://nanno.dip.jp/softlib/program/rlogin_x64.zip
unzip -o rlogin_x64.zip
mkdir $PBL_HOME/rlogin/
mv -f RLogin.exe $PBL_HOME/rlogin/

########################################
# teraterm

cd $TMP
gui_wget https://ja.osdn.net/frs/redir.php?m=iij&f=%2Fttssh2%2F66795%2Fteraterm-4.93.exe
unzip -o teraterm-4.93.zip
mv -f teraterm-4.93 $PBL_HOME/teraterm

########################################
# cURL

cd $TMP
wget https://dl.uxnr.de/build/curl/curl_winssl_msys2_mingw64_stc/curl-7.52.1/curl-7.52.1.zip
unzip -o curl-7.52.1.zip
mkdir $PBL_HOME/curl
mv -f src/curl.exe $PBL_HOME/curl/


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






