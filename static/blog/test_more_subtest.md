最近変化点が多すぎて追い掛けきれなかった`Test::More`のALPHA版情報です。

リポジトリはGitHubで参照することができます。

[https://github.com/Test-More/test-more](https://github.com/Test-More/test-more)

なお、あくまでまだ正式リリース前のALPHA版の話ですので、注意して下さいね。

# subtestの表示方法の変更

`Test::More`の`subtest`といえば、テストファイルのテストを構造化する手段として欠かせない仕組みです。

簡単なsubtestを使ったテストコードの例です。

	use strict;
	use warnings;
	
	use Test::More;
	
	subtest 'sub test' => sub {
		ok(1, 'first test');
		ok(0, 'second test');
	};
	
	done_testing;


実行すると、こうなります。

	$ perl test.t
		# Subtest: sub test
		ok 1 - first test
		not ok 2 - second test
		#   Failed test 'second test'
		#   at test2.t line 8.
		1..2
		# Looks like you failed 1 test of 2.
	not ok 1 - sub test
	#   Failed test 'sub test'
	#   at test2.t line 9.
	1..1
	# Looks like you failed 1 test of 1.


インデントされた箇所がサブテストの明細で、最後の`not ok 1 - sub test`がサマリーです。`prove`コマンドはインデントされた箇所を全てスキップして、最後のサマリーだけを拾ってテストの成否を判定します。

`Test::More`が出力する内容は[`TAP(Test Anything Protocol)`](http://testanything.org)という形式に従っています。しかし、実は`TAP`の仕様では、`subtest`は定義されていません。`Test::More`モジュールの独自(?)機能です。

`subtest`は簡単にテストが構造化できる反面、明確に定義された仕様も無いし、第一明細が先に表示されるという形式がとても読みづらいです。

上記の例であればまだマシですが、`subtest`はネストできるので、ますますどこを読めば良いのか分からない表示になってしまいます。

それを改善しようという試みが`Test::More`のALPHA版にマージされた`delayed`モードです。

テストコード例は以下の通りです。

	use strict;
	use warnings;
	
	use Test::Stream subtest_tap => 'delayed';
	use Test::More;
	
	subtest 'sub test' => sub {
		ok(1, 'first test');
		ok(0, 'second test');
	};
	
	done_testing;


見慣れない「`use Test::Stream subtest_tap => 'delayed';`」という行が追加になっています。

実行してみましょう。

	$ perl -Ilib test.t
	not ok 1 - sub test {
	#   Failed test 'sub test'
	#   at test.t line 10.
		ok 1 - first test
		not ok 2 - second test
		#   Failed test 'second test'
		#   at test.t line 9.
		1..2
		# Looks like you failed 1 test of 2.
	}
	1..1
	# Looks like you failed 1 test of 1.

明細がサマリーの後ろに表示される様になりました。従来の記法と区別するために、`{}`で囲まれている点が異なります。

これなら、素直にテストが失敗した行の後ろを順に見ていけばいいので、特にネストした`subtest`の時に見やすくなったと思います。

	$ perl -Ilib test.t
	not ok 1 - sub test {
	#   Failed test 'sub test'
	#   at test.t line 15.
		ok 1 - first test
		not ok 2 - sub sub test {
		#   Failed test 'sub sub test'
		#   at test.t line 12.
			not ok 1 - nested test
			#   Failed test 'nested test'
			#   at test.t line 11.
			1..1
			# Looks like you failed 1 test of 1.
		}
		ok 3 - second test
		1..3
		# Looks like you failed 1 test of 3.
	}
	1..1
	# Looks like you failed 1 test of 1.

正式リリースに入るかは分かりませんが（以前このブログで紹介した`helper`関数はなくなっちゃいました…）、がんがんアップデートが続く`Test::More`は要チェックです。

