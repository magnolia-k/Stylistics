まだ全然完成していませんが、`HTTP::Client::Any`というモジュールを作り始めました。

[https://github.com/magnolia-k/HTTP-Client-Any](https://github.com/magnolia-k/HTTP-Client-Any)

# 作った動機

`Perl`の`http`アクセス用のモジュール事情はなかなか複雑です。

- `perl 5.14`以降は`HTTP::Tiny`がコアモジュール入り

 [http://search.cpan.org/dist/HTTP-Tiny/](http://search.cpan.org/dist/HTTP-Tiny/)

 ただし、`https`アクセスには別途`IO::Socket::SSL`のインストールが必要。

 また、デフォルトでは証明書のチェックをしない点は注意が必要です(`verify_SSL`オプションを有効にする必要があります)。

- 定番は`LWP`

 [http://search.cpan.org/dist/libwww-perl/](http://search.cpan.org/dist/libwww-perl/)

 コアモジュールではないので、別途インストールが必要。

 `Mac OS X`では、システムperlと一緒にインストールされている。

 ただし、`https`アクセスに必要な`LWP::Protocol::https`はインストールされているが、セットで必要な`Mozilla::CA`がインストールされていないので、結局`https`アクセスをするとエラーになってしまう。

- 最近よく使われる`Furl`

 [http://search.cpan.org/dist/Furl/](http://search.cpan.org/dist/Furl/)

 `LWP`は機能が多い分、インストールされる依存モジュールも多いし、場合によっては速度も遅いという問題が有って、最近よく使われるのが`Furl`です。

 しかし、必ずしもインストールされているわけではありません。

- Perl 5.12以前は、コアモジュールに`HTTP`アクセスモジュール無し

 `HTTP::Tiny`がコアモジュール入りしたのは、perl 5.14以降なので（当たり前ですが）、perl 5.12以前ではコアモジュールだけでは`http`アクセスできません。

# HTTP::Client::Any

`cpanfile`に必要なモジュールを書けばいいだけの様な気もしますが、インストールされているモジュールに合わせて、最適な`HTTP`アクセスモジュールを選択する`HTTP::Client::Any`というモジュールを書きました。

まだ作り始めたばかりなので、`get`メソッドしかサポートしていません。

使い方は、`HTTP::Client::Any`のオブジェクトを作るだけです。

    require HTTP::Client::Any;

    my $agent = HTTP::Client::Any->new;
    my $res = $agent->get( 'http://www.yahoo.co.jp' );

    if ( $res->is_success ) {
        print $res->content;
    }

`Furl -> LWP -> curl -> HTTP::Tiny`という優先順位で、インストールされているモジュールに合わせてアクセスするモジュールを選択します。

`curl`は外部コマンドを`IPC::Cmd`経由で実行します。

`https`アクセスの場合は、コンストラクタに`https`引数を渡します。

    require HTTP::Client::Any;

    my $agent = HTTP::Client::Any->new( https => 1 );
    my $res = $agent->get( 'https://github.com' );

    if ( $res->is_success ) {
        print $res->content;
    }

`https`アクセスに必要な`IO::Socket::SSL`や、`LWP::Protocol::https`がインストールされているかチェックします。

まだ全然テストしていないので、ちゃんと動かないと思いますが、次はダウンロードメソッドのmirrorを実装します。