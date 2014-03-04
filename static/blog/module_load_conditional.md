前回のエントリでは、[`Module::Build`](http://search.cpan.org/dist/Module-Load/)を紹介しましたが、今回は[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)の紹介です。

## モジュールの存在チェック

あるモジュールが利用できるかは、`require`関数をブロック形式の`eval`で確認することができます。

    eval {
        require JSON;
    };

    if ( $@ ) {
    }

## Module::Load::Conditional
しかし、やはりいちいち`eval`を書いて、戻り値の`$@`をチェックするのも煩わしいところです。

そんな時には、今回紹介する[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)が便利です。

[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)は`can_load`という関数を提供します。

### can_load

    use Module::Load::Conditional qw/can_load/;
    
    my $modules = {
        'JSON'  => '2.90',
        'YAML'  => '0.90',
    };
    
    can_load( modules => $modules ) or die "Can't load modules\n";

`can_load`は、modules引数に渡したハッシュリファレンスを元にモジュールがインストールされているかチェックします。バージョンもチェックします。

指定したモジュールが全てインストールされていれば、全てのモジュールをロードします。

`can_load`には、version 0.60以降ではautoloadという引数が指定可能です。

    can_load( modules => $modules, autoload => 1 )

autoloadモードでは、内部で[`Module::Build`](http://search.cpan.org/dist/Module-Load/)の`autoload`関数を使って、モジュールの関数をインポートします。

### check_install

[`Module::Load::Conditional`](http://search.cpan.org/dist/Module-Load-Conditional/)は、`check_install`という関数も提供しています。こちらは`can_load`と違って、インストールの確認だけです。

    use Module::Load::Conditional qw/check_install/;
    
    check_install( module => 'JSON', version => 2.90 )
        or warn 'JSON 2.90 is not installed.';

`can_load`の中では`check_install`を使っていますが、単体で利用することはあまり無いでしょう。

## おわりに

私が書いたのは`Module::Load`の`autoload`関係のドキュメントと、`Module::Load::Conditional`の`autoload`モードを追加するパッチですが、何か気がついたことが有れば、issueを上げてもらえれば幸いです。

[https://github.com/jib/module-load/commit/a3f56b9feb4d77c584f7afc7999b9e23fbaadfbc](https://github.com/jib/module-load/commit/a3f56b9feb4d77c584f7afc7999b9e23fbaadfbc)

[https://github.com/jib/module-load-conditional/commit/aed22ae81d523c8fe90c710747b962a727adc651](https://github.com/jib/module-load-conditional/commit/aed22ae81d523c8fe90c710747b962a727adc651)
