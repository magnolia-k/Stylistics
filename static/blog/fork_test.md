Test::Moreの新機能を紹介するシリーズです。

7/7時点ではまだ開発バージョン(1.301001_005)でしか使えませんので、注意して下さい。

前回は`helpers`を紹介しましたが、今回はforkのサポートについてです。

以前のバージョンの`Test::More`はforkをサポートしていませんでした。

    use strict;
    use warnings;
    use Test::More tests => 2;
    
    ok(1, "Result in parent" );
    
    if (my $pid = fork()) {
        waitpid($pid, 0);
    } else {
        ok(1, "Result in child");
        exit 0;
    }

上記のコードを実行してみます。

	$ perl fork.t 
	1..2
	ok 1 - Result in parent
	ok 2 - Result in child
	# Looks like you planned 2 tests but ran 1.

okが二つ表示されていますが、子プロセスが出力した結果が捨てられてしまって、結果的にテストは失敗しています。

以前はforkをサポートするために、[`Test::SharedFork`](http://search.cpan.org/dist/Test-SharedFork/lib/Test/SharedFork.pm)というモジュールを使うのが定番でしたが、新しいTest::Moreにはforkのサポートが入りました。

`enable_forking`と、`cull`関数がポイントです。

    use strict;
    use warnings;
    use Test::More tests => 2, qw/enable_forking/;
    
    ok(1, "Result in parent" );
    
    if (my $pid = fork()) {
        waitpid($pid, 0);
        cull();
    } else {
        ok(1, "Result in child");
        exit 0;
    }

実行してみましょう。

	$ perl -Ilib new_fork.t 
	1..2
	ok 1 - Result in parent
	ok 2 - Result in child

ちゃんと子プロセスの結果を親プロセスで収集できました。

ちなみに[`Test::SharedFork`](http://search.cpan.org/dist/Test-SharedFork/lib/Test/SharedFork.pm)の実装も、`Test::More`のアップデートに合わせて、新しいバージョンのTest::Moreがインストールされている場合は、そちらを使うようになっています。

普通に使う分には、いちいちcullを呼ばなくても勝手にマージしてくれるので、[`Test::SharedFork`](http://search.cpan.org/dist/Test-SharedFork/lib/Test/SharedFork.pm)を使った方が使い勝手はいいようです。

タイミングを自分で制御したい時は、直接cullを使った方が良いと思います。
