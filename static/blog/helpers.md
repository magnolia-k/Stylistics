2014/07/07:追記

この記事を書いてみて、よく読み返すと`nesting_helpers`関数が全然有効に動作していない事に気がつきました。

GitHubに[issue](https://github.com/Test-More/test-more/issues/413)を挙げたところ、`nesting_helpers`関数は無くなり、代わりに1.301001_005で、`nest`関数が導入されました。

よって、この記事は既に古くなりました。新しく、[新しいTest::Moreに導入されるhelpersとnest関数について](http://code-stylistics.net/archives/helpers_update.html)という記事で書き直したので、そちらを参照して下さい。

============

もうすぐリリースされるTest::Moreの新しいバージョンに`helpers`と、`nesting_helpers`という便利な関数が二つ導入されます。

(7/5時点では開発バージョンである1.301001_002がcpanにアップされています)

## helpers

似たようなテストをセットで繰り返し実行する必要があるときなどに、複数のテストを一つの関数にまとめることが有ると思いますが、`helpers`はそんな時に便利な関数です。

実際の使い方を見てみましょう。

	  1 use strict;
	  2 use warnings;
	  3 use Test::More;
	  4 
	  5 helpers 'helped';
	  6 
	  7 sub helped {
	  8     my $person = shift;
	  9     ok($person->{name},      'helped name test');
	 10     ok($person->{age} >= 20, 'helped age test' );
	 11 }   
	 12 
	 13 sub not_helped {
	 14     my $person = shift;
	 15     ok($person->{name},      'not helped name test');
	 16     ok($person->{age} >= 20, 'not helped age test' );
	 17 }   
	 18 
	 19 helped(     { name => 'foo', age => 19 } );
	 20 not_helped( { name => 'foo', age => 19 } );
	 21 
	 22 done_testing;

実行してみると、違いがすぐに分かります。

	$ perl -Ilib test.t 
	ok 1 - helped name test
	not ok 2 - helped age test
	#   Failed test 'helped age test'
	#   at test.t line 19.
	ok 3 - not helped name test
	not ok 4 - not helped age test
	#   Failed test 'not helped age test'
	#   at test.t line 16.
	1..4
	# Looks like you failed 2 tests of 4.

`helpers`を適用した関数はテストが失敗した時に、関数が実行された行番号を表示しています(19行目)。

`helpers`を適用していない関数はテストが失敗した時に、テストメソッドが定義されている箇所の行番号を表示しています(16行目)。

テストの名前は分かっているし、せっかく関数でまとめているので、まとめた関数が実行された行が分かった方がテストが失敗した時の解析に便利ですね。

## nesting_helpers

`nesting_helpers`もテストスクリプトの中でテスト用の関数を定義する時に便利な関数です。

コードブロックを引数に受け取って、関数の前後にsetupやteardownを差し込むことができます。

また、引数で与えたコードブロック自体が成功したか、失敗したかもチェックできます（それ自体をテストとしてチェックできます）。

例を見てみましょう。

	  1 use strict;
	  2 use warnings;
	  3 use Test::More;
	  4 
	  5 nesting_helpers 'helped';
	  6 
	  7 sub helped(&) {
	  8     my ($code) = @_;
	  9     diag( 'setup' );
	 10     ok( $code->(), 'test ran' );
	 11     diag( 'teardown' );
	 12 }
	 13 
	 14 helped {
	 15     my $person = { name => 'foo', age => 19 };
	 16     ok($person->{name},      'helped name test');
	 17     ok($person->{age} >= 20, 'helped age test' );
	 18 };  
	 19 
	 20 done_testing;

実行してみましょう。

	$ perl -Ilib nest_test.t 
	# setup
	ok 1 - helped name test
	not ok 2 - helped age test
	#   Failed test 'helped age test'
	#   at nest_test.t line 17.
	not ok 3 - test ran
	#   Failed test 'test ran'
	#   at nest_test.t line 10.
	# teardown
	1..3
	# Looks like you failed 2 tests of 3.

コードブロックの中で失敗していることもちゃんと分かりますね。

と言うわけで、`Test::More`の新しいバージョンに導入される`helpers`と、`nesting_helpers`を上手く使うと読みやすく、解析し易いテストが書ける様になるので、正式リリースされたらぜひ使ってみて下さい。

