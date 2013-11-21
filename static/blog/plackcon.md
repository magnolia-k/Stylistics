[Shibuya Plack/PSGI Conference (shibuya.pl) #1 #plackcon](http://atnd.org/events/45276)というイベントへ行ってきました。

[Plack](http://plackperl.org)関係の勉強会です。

場所はヒカリエに入っているLINE株式会社のカフェスペース。最近よくイベントが開かれる場所ですね。

最近ようやくPlack + Amon2という構成でWebアプリに入門したばかりだったので、「全部分かる！」という訳にはいきませんでしたが、いくつか気になったことを。

# 基調講演

[面白法人カヤック](http://www.kayac.com)の藤原さんによる基調講演。

[http://dl.dropboxusercontent.com/u/224433/plackcon/index.html](http://dl.dropboxusercontent.com/u/224433/plackcon/index.html)

まぁ、スライド見てもらうのが早いんですが、ログ周りで[`Plack::Middleware::AxsLog`](https://metacpan.org/pod/Plack::Middleware::AxsLog)がかなり便利そうです。

確かに、普通にアクセスログを出すだけだったら、フロントのWebサーバがアクセスログを出しているので、APサーバ側で出すログは特定条件だけで出してもらった方が便利ですね。

# Plack::Requestとエンコーディング

moznionさんによる`Plack::Request`のエンコーディング周りの話と、モジュールの紹介。

[http://www.slideshare.net/moznion/plackrequest-with-encoding](http://www.slideshare.net/moznion/plackrequest-with-encoding)

「職人が心をこめて書いている」が一番好きな箇所でした。

最初、画面が映らず、発表が前後しましたが、無事に発表出来て良かったです。

ついてこれない奴はいい！というさっぱり感溢れる進行が良かったですね。

# .psgiからの卒業

songmuさんの発表。

[http://songmu.github.io/slides/plackcon1/](http://songmu.github.io/slides/plackcon1/)

plackup + .psgiは最初はいいけど、結局別のランチャースクリプトを作った方がいい、という話でした。

# おわりに

あと、最後のtasukuchanさんによる発表は、年齢層的に本当に「きまぐれオレンジロード」ネタを理解していたのかが一番不思議でした。

ずっと相手にして頂いたytnobodyさん、ありがとうございました！

次は[perl-beginners #11](http://www.perl-beginners.org)です。
