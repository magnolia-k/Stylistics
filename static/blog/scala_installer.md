# scalaをセットアップするコマンドを書いた

前回の記事で、scalaを始めるにあたって、一番基本的な事をまとめたけど、scalaとsbtとscala-docがバラバラに配布されていて、インストールが面倒だなと思った。

perlでいえば、perl本体とperldocとcpanコマンドが別々に配布されているようなものか。

と言うわけで、ssup(scala and sbt setup)というコマンドをperlで書いた。

[https://github.com/magnolia-k/p5-ssup](https://github.com/magnolia-k/p5-ssup)

以下のコマンドで、`scala`ディレクトリを作って、その中にscalaとsbtとscala-docの最新版がインストールされます。

    $ curl -L http://goo.gl/JFJITE | perl
    
インストール先のディレクトリや、バージョンの指定もOKです。

    $ curl -LO https://raw.githubusercontent.com/magnolia-k/p5-ssup/master/ssup
    $ chmod +x ssup
    $ ./ssup --dir=path/to/install --scala=2.11.4 --sbt=0.13.6

Mac OS Xでテストしていますが、他のLinux等でも変わらず使えると思います。

ターゲットのperlのバージョンはコアモジュールの関係からperl 5.14以上をしているので、注意して下さい。