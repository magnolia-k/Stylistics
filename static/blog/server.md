このサイトは、[Cent OS](http://www.centos.org) + [Starman](http://search.cpan.org/dist/Starman/) + [Amon2](http://amon.64p.org)という構成で動いています。

その構築した時に調べたことのメモです。

# Starman

Web+APサーバには[Starman](http://search.cpan.org/dist/Starman/)を使っています。

フロントにApacheや、Nginxの様なWebサーバを設置しないで直接PSGI/Plackサーバで80番ポートをlistenする構成にしたかったので、workerプロセスのユーザーIDと、グループIDが設定できる[Starman](http://search.cpan.org/dist/Starman/)を選択しています。

後述するupstartにも、ユーザーIDや、グループIDを設定する機能が有りますが、残念ながらCent OS 6に搭載されているバージョンではまだ使えないようです。

# daemon化

アプリのdaemon化にはCentOS 6から使えるようになった[upstart](http://upstart.ubuntu.com)を使っています。

upstartは、daemon化したいアプリケーションごとに設定ファイルを用意して、`/etc/init/`配下へ設置するだけで準備が完了します。

`-> stylistics.conf`

	description "code-stylistics.net upstart script"	author "magnolia <magnolia.k@me.com>"		start on runlevel [2345]	stop on runlevel [!2345]		respawn	respawn limit 5 60		chdir /Stylistics/		script		/usr/local/carton exec /usr/local/perl -Ilib /Stylistics/script/stylistics-server --host=code-stylistics.net --port=80 --user=www --group=www	end script## 起動    $ sudo initctl start stylistics
## 停止
    $ sudo initctl stop stylistics

# その他

まだログの管理がちゃんと出来ていないので、ログ管理を改善したら、追記します。

