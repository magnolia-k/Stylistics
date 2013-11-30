先日、[`HTTP::Client::Any`](https://github.com/magnolia-k/HTTP-Client-Any)というモジュールを書いて、[PrePAN](http://prepan.org/module/nXWJ8Y9sBwK)にアップしてみましたが、やはり「使い道なくね？」というコメントをもらいました。

やっぱり…という感じですが、せっかくなので、その時に調べたことを色々と残しておきます。

# LWP::UserAgentと、HTTP::Tinyのmirrorメソッド

[`HTTP::Tiny`](http://search.cpan.org/dist/HTTP-Tiny/)と、[`LWP::UserAgent`](http://search.cpan.org/dist/libwww-perl/)には、ファイルのダウンロードを行うための`mirror`というメソッドが有ります。

このメソッドは、URIとファイルパスを引数に渡して起動すると、URIが指しているコンテンツをファイルに保存します。

    use HTTP::Tiny;

    my $ua = HTTP::Tiny->new;
    my $uri = 'http://www.cpan.org/src/5.0/perl-5.18.1.tar.gz';
    my $res = $ua->mirror( $uri, 'perl-5.18.1.tar.gz' );
    
    if ( $res->{success} ) {
        ... # file download is success...
    }

メソッドの結果を判定する方法が若干異なるだけで、[`LWP::UserAgent`](http://search.cpan.org/dist/libwww-perl/)でも使い方は同じです。

## if-modified-sinceヘッダの送信

mirrorメソッドはダウンロード対象のファイルが指定したパスに存在していても、`if-modified-since`というヘッダにファイルの更新日時をセットして、httpリクエストを飛ばします。

`if-modified-since`というhttpヘッダについては、[「鳩丸ぐろっさり」というサイトの解説](http://bakera.jp/glossary/If-Modified-Since)がシンプルで分かりやすいと思いますが、より更新日時が新しいコンテンツが有る時のみレスポンスを返して！という意味です。

更新日時が新しい物が無ければ、ステータスコードは304が返って来ます。

その際、[`HTTP::Tiny`](http://search.cpan.org/dist/HTTP-Tiny/)も、[`LWP::UserAgent`](http://search.cpan.org/dist/libwww-perl/)も、レスポンスオブジェクトは成功扱いです（別に何か失敗した訳では無いので）。

あと、サーバ側がレスポンスヘッダに`last-modified`を付加した時は、ダウンロードしたファイルの更新日時を、`last-modified`ヘッダの日付で更新します。

これは`if-modified-since`に渡すファイル更新日時をなるべくサーバ側で管理しているものに合わせるためです。

なぜファイルをダウンロードするメソッドが、downloadではなく、mirrorという名前なのか、これでよく分かりますね。

## Furlとmirrorメソッド
[`Furl`](http://search.cpan.org/dist/Furl/)にはmirrorメソッドは有りませんが、LowレベルAPIである`Furl::HTTP`モジュールのrequestメソッドにファイルハンドルを渡しておくと、レスポンスのボディ部をファイルに保存してくれる機能があるので、こちらを使えば同様のことができます。

`if-modified-since`まで真面目に実装すると面倒ですが、単に大きなファイルをダウンロードしたいだけなら、そこまでする必要も無いでしょう。


# Furlと、LWP::UserAgentのdecoded_contentメソッド

[`Furl`](http://search.cpan.org/dist/Furl/)と、[`LWP::UserAgent`](http://search.cpan.org/dist/libwww-perl/)には`decoded_content`というメソッドが有ります。

`content`メソッドは、単に受信したhttpレスポンスのコンテンツをそのまま返すだけですが、`decoded_content`は、文字コードを判別してdecodeした（perlの文字列に変換した後の）コンテンツを返します。

`Content-Type`や、htmlのmetaデータを参照して文字コードを取得し、Encodeモジュールでperl文字列に変換した結果を返してくれます。

内部では、HTTP::Messageが全部面倒を見てくれるようです。

いちいち自前で変換するのは面倒だし、perlの外取得した以降はすべてperlの文字列として処理するのが原則なので、`decoded_content`メソッドが使えるなら、なるべく使った方がいいでしょう。

