# このリポジトリは
- pbl.zipの生成方法を記載

- setup.sh
  - pbl.zip生成の全手順
  - バイナリの取得から，ディレクトリの移動，設定ファイルの書き換え全ての手順が含まれる
  - guiによる手作業処理も含まれるので全自動ではないことに注意

- delta/
  - 差分となる全ての設定ファイルを保持
  - 初期状態（orig）との差分を見るとよい

- pbl.zip
  - zip自体は巨大なので本リポジトリとは別のファイルサーバに待避
  - http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/

# Release note
### 1.0
- http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/pbl_v1.0.zip
- `2017/02/03`
- 初期バージョン

# Pendings
### java実行時の候補
- javaの`static main()`実行時の候補がイマイチ
- サーバ実行とjava実行の両方が出る
- 後者だけで十分
- 学生が演習時にミスりそう

### tomcatユーザーどうする？
- `tomcat-users.xml`
- 現在，alpacaでのbuildデプロイ時に以下コマンドを実行している
```bash
cp *.war $PBL_HOME/webapps
```
- tomcat api経由でデプロイすべき
- そうなるとtomcatユーザが必須


### httpd必要？
- httpd-tomcatの謎連携をやめたため，今のところ不要
- 謎連携はtomcatのみで実現可能
```xml
<context path=.. docBase=..>
```


### tomcatのanti*Lockingを外したが問題ないか？
- tomcat/conf/context.xml内
```xml
<Context antiResourceLocking="true" "antiJARLocking="true">
```
- 今のところ問題は出ていないが，実際に開発しながら試すべき




# What's pbl.zip?
- ポータブルで動くcloud spiralの演習・開発環境
- Java, Eclipse全部入り

- 動作環境
  - win7 or later
  - 64bit
  - 2GB HDD space
  - C:\pbl上でのみ動作

### JDK
- 8u121
- 理由：最新・8系統

### Eclipse
- http://mergedoc.osdn.jp/
- 4.6 Neon, Pleiades All in One, x64
- Java → x64 → Standard Edition
- 理由：最新・日本語化のためpleiades

### Apache Tomcat
- 8.5.11, Core → zip
- 理由：最新・8系統

### Mongodb
- 3.4.1
- "w/o SSL support x64"
- 理由：最新 stable

### RLogin
- http://nanno.dip.jp/softlib/man/rlogin/
- 2.21.3, x64
- 理由：最新

### teraterm
- http://ttssh2.osdn.jp/
- 4.93
- 理由：最新

### cURL
- https://curl.haxx.se/
- 7.52.1
- "Win64 - Generic"→ "Win64 x86_64 zip"
- 理由：最新

### Google Chrome
- https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/
- 46.0.2490.86 (Official Build) （64 ビット）
- 理由：webrtc:navigator.getUserMediaがchrome v47からhttpsオンリーになったため
