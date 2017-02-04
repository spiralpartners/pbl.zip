# javaのstatic main()実行時の候補がイマイチ
- サーバ実行とjava実行の両方が出る
- 後者だけで十分 

# tomcatユーザーどうする？
- tomcat-users.xml

- 現在，alpacaでのbuildデプロイ時に以下コマンドを実行している
> cp *.war $PBL_HOME/webapps

- tomcat api経由でデプロイすべき
- そうなるとtomcatユーザが必須


# httpd必要？
- httpd-tomcatの謎連携をやめたため，今のところ不要
  - 謎連携はtomcatのみで実現可能
  > <context path=.. docBase=..>


# tomcatのanti*Lockingを外したが問題ないか？
- tomcat/conf/context.xml内
> <Context antiResourceLocking="true" "antiJARLocking="true">

- 今のところ問題は出ていないが，実際に開発しながら試すべき


