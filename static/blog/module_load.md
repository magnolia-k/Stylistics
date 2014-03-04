年末年始にかけてPerlのコアモジュールの[`Module::Load`](http://search.cpan.org/dist/Module-Load/)と、[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)のドキュメントやパッチを書いていました。

Perl v5.10以降でコアモジュール入りした、これらのモジュールの使い方を改めて解説すると共に、最近追加されたautoload機能についても解説します。

## require関数

`require`関数は、実行中にモジュールのロードを行う関数ですが、引数にはベアワードのパッケージ名か、モジュールのファイルへのパスを取ります。

    require Data::Dumper;

    or

    require 'Data/Dumper.pm';

実行時に動的にロードするモジュールを決める場合は、変数に格納したくなりますが、これはNGです。

    my $module = 'Data::Dumper';
    require $module;

    # -> Can't locate Data::Dumper in @INC ...

動的にモジュールを指定したい時は、`eval`を使って文字列をベアワードに変換するというトリッキーな技を使います。

    my $module = 'Data::Dumper';
    eval( "require $module" );

しかし、モジュールをロードするためにいちいち`eval`を書いて、結果を`$@`の中身を見て判定するのも面倒です。

こんな時には、`Module::Load`を使います。

## Module::Load

    use Module::Load;

    my $module = 'Data::Dumper';
    load $module;

`Module::Load`をuseすると、`load`関数がエクスポートされます。この`load`関数を使えば変数でモジュールを指定することができます。

結局は`load`関数の中で文字列を引数に取る`eval`を実行しているだけですが、スクリプトがすっきりするし、コアモジュールなのでお勧めです（同様の機能を提供する[`UNIVERSAL::require`](http://search.cpan.org/dist/UNIVERSAL-require/)も有りますが、コアモジュールではありません）。

### autoload

どちらかというと臭い物に蓋をする的なモジュールだった`Module::Load`ですが(`eval`は割とトリッキーな機能なので、多用するとコードの意図が分かりづらくなる欠点が有ります)、version 0.26から新たに`autoload`という関数が追加されました。

明示的に指定しないとインポートされない関数なので、注意して下さい。

    use Module::Load qw/autoload/;

    my $module = 'Data::Dumper';

    autoload $module;

    my $data = {
        text => 'dumped',
    };

    print Dumper( $data );

`require`関数は、`use`と違って関数をインポートしませんが、`autoload`を使うとインポートまでやってくれます（ただし、デフォルトでエクスポートされる関数のみが対象で、エクスポートする関数を指定することはできません）。

`use`は`require`と違って実行時ではなく、コンパイル時に動作するプラグマなので、実行中に動的にロードするモジュールを指定することはできませんが、`autoload`を使うと同じことができます。

### autoload_remote

`autoload`と同じタイミングで追加されたのが、`autoload_remote`関数です。

`autoload`関数は、モジュールをロードし、関数をインポートしますが、インポート先は`autoload`関数を実行しているパッケージになります。

`autoload_remote`は、インポートするパッケージを指定できます。

    use Module::Load qw/autoload_remote/;
	
    my $module = 'Data::Dumper';
	
    autoload_remote 'DumpPkg', $module;
	
    package DumpPkg;
	
    my $data = {
        text => 'dumped',
     };
	
    print Dumper( $data );
    # $VAR1 = {
    #          'text' => 'dumped'
    #         };

使い方を間違えると、どこでパッケージに関数がインポートされたのか見えなくなってしまいますので、気をつけて使いましょう。

## おわりに

次回は、[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)を紹介します。