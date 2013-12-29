[`ExtUtils::MakeMaker`](http://search.cpan.org/dist/ExtUtils-MakeMaker/)にパッチが採用されました。

[https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/pull/77](https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/pull/77)

meta-specにver 2を指定したらCONFIGURE_REQUIREの内容がCPAN Meta fileに出力されない事象を修正するパッチです。

何回ドキュメント読んでも挙動が合わないので、延々とコードを読み進めていくと、meta-specのバージョンによって出力内容を変えている箇所が有るんですが、そこにちゃんとmeta-spec ver 2を考慮できていない箇所が有ったので、そこを修正しました。

これで、Makefile.PLのMETA-MERGEセクションに、meta-spec ver 2を指定しても、CONFIGURE_REQUIREの内容が正しく反映されます。

