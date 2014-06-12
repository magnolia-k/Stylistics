[Shunme](https://github.com/magnolia-k/p5-Shunme)というperlのモジュールを書き始めました。

先日リリースした[TAP::Tree](https://metacpan.org/release/TAP-Tree)は、このモジュールを書いている最中に、先に書いた部分を独立したものです。

いわゆるテストハーネスコマンドです。

Perlのコアモジュールに含まれる`prove`コマンドが、`block I/O`ベースなので、十分な並列処理ができないという問題を解決してみようという実験です。

[https://github.com/Perl-Toolchain-Gang/Test-Harness/issues/30](https://github.com/Perl-Toolchain-Gang/Test-Harness/issues/30)

    $ uma
    $ uma --blib
    $ uma -v

`uma`というコマンドが用意されていて、実行すると`t`ディレクトリ配下の`*.t`を全部実行します。

最後にテストの結果

UNIXの`poll`というシステムコールを使って`non-blocking I/O`を実現しています。

上手くいけば、`prove`より速く処理が終わります。（逆に遅くなるときも有ります）

まだ、やっつけコードもいっぱい残っていますが、使ってみてissueをあげて頂けると幸いです。