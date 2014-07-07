もうすぐリリースされるTest::Moreの新しいバージョンに`helpers`と、`nest`という便利な関数が二つ導入されます。

(7/7時点では開発バージョンである1.301001_005がcpanにアップされています。いくつか開発バージョンがアップされていますが、nest関数は1.301001_005で導入されました)

## helpers

複数のテストをセットで繰り返し実行する必要があるときなどに、その複数のテストを一つの関数にまとめることが有ると思いますが、`helpers`はそんな時に便利な関数です。

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

## nest

`nest`関数を`helpers`関数と組み合わせることで、実行したいテスト関数の前後にsetupやteardownを差し込むことができます。

また、引数で与えたコードブロック自体が成功したか、失敗したかもチェックできます（それ自体をテストとしてチェックできます）。

例を見てみましょう。

	  1 use strict;
	  2 use warnings;
	  3 
	  4 use Test::More;
	  5 
	  6 helpers 'helped';
	  7 
	  8 sub helped(&) {
	  9     my ($CODE) = @_;
	 10 
	 11     diag( 'setup' );
	 12     ok( nest { $CODE->() }, 'test ran' );
	 13     diag( 'teardown' );
	 14 }
	 15 
	 16 helped {
	 17     ok(0 ,'helped test' );
	 18 };
	 19 
	 20 done_testing;

実行してみましょう。

	$ perl -Ilib nesting_helpers.t 
	# setup
	not ok 1 - helped test
	#   Failed test 'helped test'
	#   at nesting_helpers.t line 17.
	not ok 2 - test ran
	#   Failed test 'test ran'
	#   at nesting_helpers.t line 18.
	# teardown
	1..2
	# Looks like you failed 2 tests of 2.

setupもteardownも実行されています。また、helpers関数で登録された関数が実行された行(18行目)でエラーが発生したと報告されてます。

と言うわけで、`Test::More`の新しいバージョンに導入される`helpers`と、`nest`を上手く使うと読みやすく、解析し易いテストが書ける様になるので、正式リリースされたらぜひ使ってみて下さい。

