########################################
# init

export VERSION="ver 1.4"

export TMP=/d/tmp/
export PBL_HOME=/c/pbl/

unalias cp
mkdir -p $PBL_HOME

########################################
cd $TMP
wget http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/hadoop-2.7.3.tar.gz
tar zxvf hadoop-2.7.3.tar.gz
rm -rf $PBL_HOME/hadoop
mv hadoop-2.7.3 $PBL_HOME/hadoop