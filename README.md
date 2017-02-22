# このリポジトリは
- pbl.zipの*生成方法*を記載
- zip自体は別サーバに待避，[release](https://github.com/spiralpartners/pbl.zip/releases)を参照

- setup-base.sh
  - pbl.zip生成手順のうち，ベースバイナリの生成手順のスクリプト
  - 生成結果はこちら
    - http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/pbl-base-v0.1.zip
  - 一部，guiによる手作業処理も含まれるており，全自動ではないことに注意

- setup-conf.sh
  - ベースバイナリに対して設定を加えるスクリプト
  - 実行パス（C:\pbl\）の固定や，Eclipseへの設定等が含まれる
  - pbl.zipの肝

- delta/
  - setup-confによる設定とデフォルト設定との差分ファイルを保持
  - 初期ファイル（.orig）との差分を見るとよい

- pbl.zip
  - zip自体は巨大なので本リポジトリとは別のファイルサーバに待避
  - http://sdl.ist.osaka-u.ac.jp/~shinsuke/pbl.zip/


# Pendings
### ~~java実行時の候補~~
- v1.2 (mergedoc→JEE）により解決
- ~~javaの`static main()`実行時の候補がイマイチ~~
- ~~サーバ実行とjava実行の両方が出る~~
- ~~後者だけで十分~~
- ~~学生が演習時にミスりそう~~

### tomcatユーザーどうする？
- `tomcat-users.xml`
- 現在，alpacaでのbuildデプロイ時に以下コマンドを実行している
  - `cp *.war $PBL_HOME/webapps`
- tomcat api経由でデプロイすべき
- そうなるとtomcatユーザが必須

### httpd必要？
- httpd-tomcatの謎連携をやめたため，今のところ不要
- 謎連携はtomcatのみで実現可能
  - `<context path=.. docBase=..>`

### tomcatのanti*Lockingを外したが問題ないか？
- tomcat/conf/context.xml内
  - `<Context antiResourceLocking="true" antiJARLocking="true">`
- 今のところ問題は出ていないが，実際に開発しながら試すべき




# What's pbl.zip?
- ポータブルで動くcloud spiralの演習・開発環境
- Java, Eclipse全部入り

| Software | version | source | memo |
|--------|---------|--------|------|
| JDK | 8u121 | [oracle.com](http://www.oracle.com/technetwork/java/javase/downloads/index.html) | x64 |
| Eclipse | 4.6.2 Neon 2 | [eclipse.org](http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/neon2) | x64 |
| Apache Tomcat | 8.5.11 | [apache.org](http://tomcat.apache.org/) | Core → zip |
| MongoDB | 3.4.1 | [mongodb.com](https://www.mongodb.com/) | w/o SSL support x64 |
| RLogin | 2.21.3 | [nanno.disp.jp](http://nanno.dip.jp/softlib/man/rlogin/) | x64 |
| Teraterm | 4.93 | [ttssh2.osdn.jp](http://ttssh2.osdn.jp/) |
| cURL | 7.52.1 | [haxx.se](https://curl.haxx.se) | x64 |
| Google Chrome | 46.0.2490.86 | [portableapps](https://sourceforge.net/projects/portableapps/files/Google%20Chrome%20Portable/) | x64 |


### 動作環境
- win7 or later
- 64bit
- 2GB HDD space
- C:\pbl上でのみ動作


### Google Chrome
- 最新chromeでは，webappクライアントの講義題材が動かないため古いバージョンを入れておく
- 詳細
  - カメラや音声の取得API`webrtc:navigator.getUserMedia`がchrome v47以降からhttpsオンリーになった
  - 証明書のインストールや，証明書の無視等の余計な手間が発生する

