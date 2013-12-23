BSD系OSでは、makeとgmakeが違うので、ハマった話です。

## CPAN Testers Reports

[CPAN](http://www.cpan.org)にperlのモジュールをアップすると、「[CPAN Testers Reports](http://www.cpantesters.org)」というサイトに、色々な環境(OSや、perlのバージョン)でモジュールのテストを実行した結果が掲載されます。

モジュールの作者が色々な環境でテストするのは難しいので、こうゆう仕組みはとても便利です。

## Enbldのテスト結果

[Enbldのテスト結果](http://www.cpantesters.org/distro/E/Enbld.html#Enbld-0.7028)を見ると、片っ端からWindows系と、BSD系OSでテストが失敗しているのが分かると思います。

Windows系で失敗しているのは想定通りですが、BSD系で失敗している理由が分かりませんでしたが、[こちらのサイトの記事](http://x68000.q-e-d.net/~68user/unix/pickup?gmake)を読んでようやく分かりました。

## 原因

BSD系では、makeがgmake(GNU make)じゃないので、Makefileが文法の違いでエラーになったようです。

[VirtualBox](https://www.virtualbox.org)に[OpenBSD](http://www.openbsd.org)の環境を作って試してみました。

確かにエラーになります。

これを解消するのはちょっとハードル高いので、[Issueだけ立てて](https://github.com/magnolia-k/Enbld/issues/6)、しばらく様子見です。

なお、OS Xと、Linuxではmakeは、実際にはgmakeなので、上手く動きます。
