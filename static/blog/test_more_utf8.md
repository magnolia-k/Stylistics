最新のTest::MoreのAlphaで、encodingのサポートがマージされました。

[`https://github.com/Test-More/test-more`](https://github.com/Test-More/test-more)

今までのTest::MoreではTAP出力用に独自のファイルハンドルを用意するので、いくら`binmode`を使ってもUTF-8な文字列を正しく取り扱えませんでした(ターミナルに正しく出力されません)。

UTF-8な文字列を扱うためにはトリッキーなコードを書く必要が有りましたが、これからはシンプルに`encoding`を指定するだけです。

    use utf8;
    use Test::More encoding => 'utf8';

    ok(0, '日本語のメッセージ');

`encoding`が`utf8`の場合は、少し短く書けます。

    use Test::More qw/utf8/;

新しく導入された`tap_encoding`関数を使ってもを指定できます。

    tap_encoding 'utf8';
    ok(0, '日本語のメッセージ');

ターミナルのエンコーディングが予め予想できない場合は、`Encode::Locale`を使います。

    use Encode::Locale;
    use Test::More;

    tap_encoding 'console_out';

早く正式リリースされるといいですね。