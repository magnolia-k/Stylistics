# Test::Harnessモジュールの構造

先日、`proveコマンド`の挙動を理解していなくて、少しハマりました。しかし、`proveコマンド`のバックエンドである`Test::Harnessモジュール`が思いの外構造が複雑でなかなか原因に到達できず、苦労しました。

せっかくなので、調べた事をまとめました。

## Perlのテストスクリプトについて

まずは、Perlのテストスクリプトについて、基本的なことをおさらいします。

### TAP - Test Anything Protocol

Perlのお作法として、テストスクリプトはTAPというプロトコルに合わせてテスト結果を出力します。

TAPは、`Test Anything Protocol`の略で、詳しい仕様は[公式サイトに解説](http://testanything.org)が有りますが、要はテストが成功すれば「ok」を表示し、失敗すれば「not ok」を表示するというシンプルなものです。

以下に簡単なテストスクリプトの例と、実行結果を示します。

	$ cat t/00-sample.t
	use Test::Simple tests => 2;

	sub double {
		my $val = shift;

		return $val * 2;
	}

	ok( 2 == double( 1 ), 'success' );
	ok( 5 == double( 2 ), 'failure' );

	$ perl t/00-sample.t
	1..2
	ok 1 - success
	not ok 2 - failure
	#   Failed test 'failure'
	#   at t/00-sample.t line 10.
	# Looks like you failed 1 test of 2.

引数で受け取った数を2倍するだけのシンプルな関数ですが、一つ目のテストは成功し、二つ目のテストが失敗していることが分かるとお分かり頂けると思います。

テストスクリプトの中で使われている[`Test::Simple`](http://search.cpan.org/dist/Test-Simple/)というモジュールについては、この後解説します。

### Test::Simpleモジュール

上記のテストスクリプトの中に出てくる[`Test::Simple`](http://search.cpan.org/dist/Test-Simple/)は、TAPの形式に合わせてテスト結果を出力するモジュールで、`ok`という関数をエクスポートします。モジュール名の後ろの`tests`は、テストの数を指定しています。

`ok`関数は引数を二つ取り、一つ目にはテスト結果、二つ目にはテストの説明を渡します。テスト結果が真ならテストは成功で、偽ならテストは失敗します。

最初に、テストの数を出力し、その後はテスト一つにつき、結果を1行で出力します。

「#」で始まる行は、テストの失敗した原因などが表示されますが、コメント扱いで、TAPとしての結果には影響しません。

ちなみに実際のテストスクリプトでは、より便利な関数を多数備えた[`Test::Moreモジュール`](https://metacpan.org/pod/Test::More)を利用することが多いと思います。

### proveコマンド

しかし、テストスクリプトの数が増えてくると、いちいち`$ perl t/xxxx.t`とファイルを指定して実行するのは面倒です。

それに、せっかく自動化するためにテストを書いたハズなのに、いちいち起動して、目視で結果を確認していたら意味が有りません。

それを解決するのが`proveコマンド`です。

もう一つテストファイルを追加します。

	$ cat t/01-addition.t
	use Test::Simple tests => 2;

	ok( 1, 'first test' );
	ok( 1, 'second test' );

引数無しで`prove`コマンドを実行すると、`t/*.t`を全て実行し、結果をサマライズして表示します。

	$ ls t/
	00-sample.t	01-addition.t

	$ prove
	t/00-sample.t .... 1/2
	#   Failed test 'failure'
	#   at t/00-sample.t line 10.
	# Looks like you failed 1 test of 2.
	t/00-sample.t .... Dubious, test returned 1 (wstat 256, 0x100)
	Failed 1/2 subtests
	t/01-addition.t .. ok

	Test Summary Report
	-------------------
	t/00-sample.t  (Wstat: 256 Tests: 2 Failed: 1)
	  Failed test:  2
	  Non-zero exit status: 1
	Files=2, Tests=4,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.04 cusr  0.01 csys =  0.10 CPU)
	Result: FAIL

急に出力される内容が増えましたが、テストスクリプトのパス名の後ろにテストスクリプトごとのテストの成否が出力され、最後にサマリーレポートが出力されているのがお分かり頂けると思います。

#### TAP形式での出力

個々のテストスクリプトの実行結果をTAP形式で見たい時は、`-v`オプションを付けます。

	$ prove -v
	t/00-sample.t ....
	1..2
	ok 1 - success
	not ok 2 - failure

	#   Failed test 'failure'
	#   at t/00-sample.t line 10.
	# Looks like you failed 1 test of 2.
	Dubious, test returned 1 (wstat 256, 0x100)
	Failed 1/2 subtests
	t/01-addition.t ..
	1..2
	ok 1 - first test
	ok 2 - second test
	ok

	Test Summary Report
	-------------------
	t/00-sample.t  (Wstat: 256 Tests: 2 Failed: 1)
	  Failed test:  2
	  Non-zero exit status: 1
	Files=2, Tests=4,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.04 cusr  0.01 csys =  0.09 CPU)
	Result: FAIL

## Test-Harnessについて

`Proveコマンド`は、`TAP::Harness`というモジュールのラッパーコマンドで、どちらも`Test-Harness`というモジュールのディストリビューションに含まれています。

`Test::Harness`という名前のモジュールも提供されていますが、後方互換性のためのインタフェースモジュールとして使われているだけで、実際には`TAP::*'というネームスペースのモジュールが使われるようになっています。

`TAP::*`のネームスペース配下には非常に多数のモジュールが含まれており、かつ拡張性を確保するためプラグイン機能が多数含まれているため、非常に動作をトレースするのが難しいのですが、基本となるモジュールは以下の通りです。

### `TAP::Objectモジュール`
`TAP::*`ネームスペースのモジュール群へのユーティリティメソッド(getter/setter/例外メソッドなど)を提供します。`TAP::*`のモジュールは全てこのモジュールを継承します。

### `TAP::Parserモジュール`

`Test::Harness`の中心的なモジュールで、テストスクリプトの実行して、TAP形式の出力をパースします。

### `TAP::Formatter::*::Sessionモジュール`

`TAP::Parserモジュール`がパースした内容を、出力先に合わせて整形します。主にコンソールに出力する`TAP::Formatter::Console::Sessionモジュール`か、ファイルに出力される`TAP::Formatter::File::Sessionモジュールが使われます。

### `TAP::Harnessモジュール`

`TAP::Parserモジュール`と、`TAP::Formatter::*::Sessionモジュール`を使って、テストの実行から結果の出力までを行う、`runtestsメソッド`を提供します。`proveコマンド`も、中ではこの`TAP::Harnessモジュール`のインスタンスを作って、`runtestsメソッド`を呼び出しています。

### `TAP::Parser::Aggregatorモジュール`

テスト結果のサマリーを集計するモジュールです。

## TAP::Harnessモジュールの動作を追い掛ける

`TAP::Harnessモジュール`は、ちょっとコードを読んだだけでは、実際にどこでテストスクリプトが起動されているのか、なかなか分かりづらい構成になっています。なので、実際にテストスクリプトが起動される箇所まで`TAP::Harnessモジュール`の動作を追い掛けて行きます。

まずは、`TAP::Harness`モジュールのSYNOPSISを確認します。基本ですね。

	use TAP::Harness;
	my $harness = TAP::Harness->new( \%args );
	$harness->runtests(@tests);

`TAP::Harness`のインスタンスを作って、`runtests`メソッドに実行したいテストを渡していることが分かると思います（`@tests`には、テストのファイル名のリストが入ります）。

#### TAP::Harnessのruntestsメソッド

`runtests`メソッドのコードは以下の様になっています。

	sub runtests {
		my ( $self, @tests ) = @_;

		my $aggregate = $self->_construct( $self->aggregator_class );

	- 省略 -

		my $run = sub {
			$self->aggregate_tests( $aggregate, @tests );
			$finish->();
		};

	- 省略 -

		if ( $self->trap ) {
			local $SIG{INT} = sub {
				print "\n";
				$finish->(1);
				exit;
			};
			$run->();
		}

`$aggregate`には、TAPの`aggregator`モジュールのインスタンスが入っています(デフォルトでは、`TAP::Parser::Aggregatorモジュール`)。

最後に`$run`というスカラーに入れたコードリファレンスを実行しているのが分かると思いますが、その中では`aggregate_testsメソッド`が呼ばれています。これがテストの実行と収集をしている箇所です。

更に追いかけて行きます。

#### TAP::Harnessのaggregate_testsメソッド

`aggregate_testsメソッド`のコードは以下の様になっています。

	sub aggregate_tests {
		my ( $self, $aggregate, @tests ) = @_;

		my $jobs      = $self->jobs;
		my $scheduler = $self->make_scheduler(@tests);

	- 省略 -

		else {
			$self->_aggregate_single( $aggregate, $scheduler );
		}

		return;
	}

テストをパラレルで実行するルートと、シリアルで実行するルートが有るんですが、今回はシリアルに実行するルートを追い掛けます（デフォルトではシリアルに実行されます）。

	sub _aggregate_single {
		my ( $self, $aggregate, $scheduler ) = @_;

		JOB:
		while ( my $job = $scheduler->get_job ) {
			next JOB if $job->is_spinner;

			my ( $parser, $session ) = $self->make_parser($job);

			while ( defined( my $result = $parser->next ) ) {
				$session->result($result);

    - 省略 -

			}

			$self->finish_parser( $parser, $session );
			$self->_after_test( $aggregate, $job, $parser );
			$job->finish;
		}

		return;
	}

`$scheduler`は、`TAP::Parser::Schedulerのインスタンス`が入っていて、実行するテストのキューを保持しています。

テストスクリプト一つにつき、一つの`TAP::Parser::Scheduler::Jobインスタンス`が作られ、`TAP::Parser::Schedulerのインスタンス`に登録されていて、それが順番に取り出されているわけです（当然パラレル実行の時は、前のテストスクリプトの実行が終わるのを待たずに次のテストを実行します）。

その下の「`my ( $parser, $session ) = $self->make_parser($job);`」という箇所で、`TAP::Parserのインスタンス`と、`TAP::Formatter::*::Sessionのインスタンス`を生成しています。

(デフォルトでは、結果をコンソールに出力するので、`TAP::Formatter::Console::Session`のオブジェクトが作成されます。)

`TAP::Parserのインスタンス`を作成する中で、実際にテストが起動され、続くwhileで、その起動したテストが終わっているかどうかチェックしています。

テストの実行が終われば、真になって結果を収集します。

`TAP::Parser`のオブジェクトが、結果を返して、`TAP::*::Session`のオブジェクトがそれを適切な出力先に出力します。

最後は結果をアグリゲーターオブジェクトに登録して終わりです。

#### TAP::Harnessのmake_parserメソッド

では、`TAP::Harnessモジュール`の`make_parser`メソッドの中を見ていきます。

	sub make_parser {
		my ( $self, $job ) = @_;

		my $args = $self->_get_parser_args($job);
		$self->_make_callback( 'parser_args', $args, $job->as_array_ref );
		my $parser = $self->_construct( $self->parser_class, $args );

		$self->_make_callback( 'made_parser', $parser, $job->as_array_ref );
		my $session = $self->formatter->open_test( $job->description, $parser );

		return ( $parser, $session );
	}

`my $parser = $self->_construct( $self->parser_class, $args );`という箇所で実際に`TAP::Parserのインスタンス`を生成しています。


`_constructメソッド`は、`TAP::Object`が提供するメソッドで、指定したモジュール名と、引数で新しいインスタンスを生成します。

実際には、`TAP::Parser`の`_initializeメソッド`が呼ばれます。

#### TAP::Parserの_initializeメソッド

    sub _initialize {
        my ( $self, $arg_for ) = @_;

    - 省略 -

        # convert $tap & $exec to $raw_source equiv.
        my $type   = '';
        my $source = TAP::Parser::Source->new;

    - 省略 -

        if ( $source->raw ) {
            my $src_factory = $self->make_iterator_factory($sources);
            $source->merge($merge)->switches($switches)
              ->test_args($test_args);
            $iterator = $src_factory->make_iterator($source);
        }


`TAP::Parser::Sourceモジュール`は、TAPの作成元を管理するモジュールで、中で更に`TAP::Parser::SourceHandlerモジュール`を使って、perlのスクリプトファイルや、他の実行形式など、とにかくTAPを生成する元ネタを管理します。

続く`$iterator = $src_factory->make_iterator($source);`の`make_iteratorメソッド`の実行で、ついに実際にテストスクリプトが起動されます。

`make_iteratorメソッド`は、`TAP::Parser::IteratorFactoryモジュール`のメソッドですが、その中では単に適切な`TAP::Parser::Iterator`のインスタンスを生成しているだけなので、ちょっとはしょって普通のテストスクリプトが実行される時に使われる`TAP::Parser::Iterator::Processモジュール`の中を見ていきます。

#### TAP::Parser::Iterator::Processの_initializeメソッド

	sub _initialize {
		my ( $self, $args ) = @_;

		my @command = @{ delete $args->{command} || [] }
		  or die "Must supply a command to execute";

		$self->{command} = [@command];

	- 省略 -

		my $out = IO::Handle->new;

		if ( $self->_use_open3 ) {

	- 省略 -

			if ($IS_WIN32) {

	- 省略 -

			}
			else {
				$err = $merge ? '' : IO::Handle->new;
				eval { $pid = open3( '<&STDIN', $out, $err, @command ); };
				die "Could not execute (@command): $@" if $@;
				$sel = $merge ? undef : IO::Select->new( $out, $err );
			}


	}

`open3`を使ってテストのスクリプトを起動しているのが分かると思います。

この後は、`next`メソッドが呼ばれる度に、別プロセスで起動したテストが終わったかどうかをチェックします。

延々と追い掛けて来ましたが、これでテストが実行され、結果が収集される基本的な流れが分かったかと思います。

## Test-Harnessのプラグインモジュール

`Test-Harness`モジュールは、プラグインモジュールに対応しています。

`TAP::Formatter::*`系のモジュールを追加し、`TAP::Parser`がパースした出力を変えるパターンが多いようですね。

しかし、CPANで検索してみると分かりますが、決して種類は多く有りません。これはきっと`Test-Harness`モジュールの構造が非常に複雑で、

### Test::Prettyモジュール

[`Test::Pretty`](https://metacpan.org/pod/Test::Pretty)は、Tokuhiromさん作のモジュールで、`proveコマンド`の出力を可愛く（？）してくれます。

	$ prove -PPretty t/01-addition.t

	✓  first test
	✓  second test

	ok

チェックマーク形式で分かりやすいですね。今回は紹介していませんが、`Test::More`モジュールのsubtestを使う時には、もっと分かりやすい表示をしてくれます。

### TAP::Formatter::HTMLモジュール

[TAP::Formatter::HTML](https://metacpan.org/pod/TAP::Formatter::HTML)モジュールは、Steve Purkisさん作のモジュールで、テスト結果をHTMLに出力します。

HTMLの生成には、Template-Toolkitを使っています。

## おわりに

`Test-Harness`モジュールに関する情報をまとめてみました。

