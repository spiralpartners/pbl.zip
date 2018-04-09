# このリポジトリは
- pbl.zipの*生成方法*を記載
- zip自体は別サーバに待避，[release](https://github.com/spiralpartners/pbl.zip/releases)を参照

- setup-base.sh
  - pbl.zip生成手順のうち，ベースバイナリの生成手順のスクリプト
  - 一部，guiによる手作業処理も含まれるており，全自動ではないことに注意

- setup-config.sh
  - ベースバイナリに対して設定を加えるスクリプト
  - 実行パス（C:\pbl\）の固定や，Eclipseへの設定等が含まれる
  - pbl.zipの肝

- setup-hadoop.sh
  - hadoopパッケージのインストール手順スクリプト

- delta/
  - setup-confによる設定とデフォルト設定との差分ファイルを保持
  - 初期ファイル（.orig）との差分を見るとよい

- pbl.zip
  - zip自体は巨大なので本リポジトリとは別のファイルサーバに待避
  - http://133.1.236.160:30080/index.php/apps/files/?dir=/Documents/pbl.zip


# What's pbl.zip?
- ポータブルで動くcloud spiralの演習・開発環境
- Java, Eclipse全部入り

| Software | version | source | memo |
|--------|---------|--------|------|
| JDK | 8u162 | [oracle.com](http://www.oracle.com/technetwork/java/javase/downloads/index.html) | x64 |
| Eclipse | 4.7.0 Oxygen | [eclipse.org](http://www.eclipse.org/downloads/packages/eclipse-ide-java-developers/oxygen3) | x64 |
| MSYS2 | 20170918 | [MSYS2](https://www.msys2.org/) | x86_64 (sf.net) |
| Apache Tomcat | 8.5.29 | [apache.org](http://tomcat.apache.org/) | Core → zip |
| MongoDB | 3.4.14 | [mongodb.com](https://www.mongodb.com/) | w/ SSL support x64 |
| RLogin | 2.21.3 | [nanno.disp.jp](http://nanno.dip.jp/softlib/man/rlogin/) | x64 |


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

