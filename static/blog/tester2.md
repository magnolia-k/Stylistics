まだ続く、`Test::More`の新機能紹介エントリーです。


今回は、`Test::Tester2`を紹介します。

なお、7/10時点では[開発バージョン1.301001_008](https://metacpan.org/release/EXODIST/Test-Simple-1.301001_008)がリリースされています。だいぶテストもちゃんと通るようになってきたようです。

## テストモジュールのテスト

これまでもテストモジュールをテストするためのモジュールがいくつか有りました。

### Test::Builder::Tester

`Test::More`には（正確に言うと、`Test::Builder`）、テストモジュールをテストするための`Test::Builder::Tester`というモジュールが付属しています。

`Test::Builder::Tester`は、TAPの出力を直接チェックします。

	use Test::Builder::Tester tests => 1;
	use Test::More;
	 
	test_out("not ok 1 - first test");

TAPの文字列を直接チェックしているため、`Test::More`のちょっとした仕様変更（サブテストの導入や、メッセージの形式を変更するとか）にとても弱いテストになりがちです。

### Test::Tester

そこで登場したのが`Test::Tester`モジュールです。

	check_test(
		sub { is_mystyle_eq("this", "that", "not eq") },
		{
		  ok => 0, # we expect the test to fail
		  name => "not eq",
		  diag => "Expected: 'this'\nGot: 'that'",
		}
	  );

使い方だけ見ると、ちょっと分かりづらいですが、`Test::Builder`のメソッドを再定義して、テスト結果をオブジェクトとして取り出せる様になっていて、そのオブジェクトを使ってテストを行います。

ただ、これも`Test::Builder`のメソッドを上書きしてしまっているので、`Test::Builder`のメンテナンスに常に追従していないと壊れてしまう、という問題が有ります。

## Test::Tester2

そこで現在の`Test::More`のメンテナであるChad Granumが導入したのが`Test::Tester2`です。

	use strict;
	use warnings;
	
	use Test::More;
	use Test::Tester2;
	
	my $results = intercept {
		ok( 1, "pass" );
		ok( 0, "fail" );
		diag( "message" );
	};
	
	ok( $results->[0]->bool,    'test - pass' );
	ok( ! $results->[1]->bool,  'test - fail' );
	like( $results->[2]->message, qr/Failed test 'fail'/, 'test - fail message' );
	is( $results->[3]->message, "message", 'test - diag' );
	
	done_testing;

新しい`Test::More`に導入されたStream機能を使って、テスト結果をオブジェクトとして取り出すことができます($resultsは、`Test::Buler::Result::xxx`オブジェクトの配列です。

`Test::More`に組み込まれているので、`Test::More`のバージョンアップにより互換性が損なわれることもありませんし、`Test::Builder::Tester`の様にTAPの文字列で比較するわけでもないので、`Test::More`の変更にも強いです。

今後は、テストモジュールをテストする時には、`Test::Tester2`がお勧めです。

