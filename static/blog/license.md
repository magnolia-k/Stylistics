perlモジュールのひな形を作る時の2014年の定番といえば、[`Minilla`](http://search.cpan.org/dist/Minilla/)ですが、少し前までは[`Module::Starter`](http://search.cpan.org/dist/Module-Starter/)でした。

乗り換えるのが面倒、という理由だけで未だに[`Module::Starter`](http://search.cpan.org/dist/Module-Starter/)を使っているんですが、ちょっと前のバージョンからディストリビューションのライセンスをデフォルトで「`Artistic_2_0`」に指定する様に変わっていました。

しかし、そのまま実行すると上手くいきません。

## `Makefile.PL`

実行するとエラーも出さずに、`MYMETA.json`や、`MYMETA.yml`の`license`指定が'`unknown`'になります。

`make metafile`で作った`META.json`や、`META.yml`の`license`指定も'`unknown`'です。

## `Build.PL`

こちらはちょっと分かりづらくて、[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされていると正常に`MYMETA.json`と、`MYMETA.yml`が作成されますが、「`Artistic_2_0`」と指定しているのに、メタファイル上のlicenseは「`artistic_2 `」になります。

[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされていないと、`Invalid metadata structure.`というワーニングが出て、メタファイルは作成されません。

## 原因

これらは、`Makefile.PL`を処理する[`ExtUtils::MakeMaker`](http://search.cpan.org/dist/ExtUtils-MakeMaker/)や、`Build.PL`を処理する[`Module::Build`](http://search.cpan.org/dist/Module-Build/)といったモジュールが、license情報をどの様に取り扱うか、その違いによるものです。

## モジュールのライセンス指定

### CPAN::Meta::Spec

当たり前ですが、モジュールのライセンスは作成者が自由に指定することができます。しかし、[`CPAN::Meta::Spec`](http://search.cpan.org/dist/CPAN-Meta/)で扱えるライセンスは以下の様に決まっています（当てはまらない物は全て`unknown`です）。

	  agpl_3
	  apache_1_1
	  apache_2_0
	  artistic_1
	  artistic_2
	  bsd
	  freebsd
	  gfdl_1_2
	  gfdl_1_3
	  gpl_1
	  gpl_2
	  gpl_3
	  lgpl_2_1
	  lgpl_3_0
	  mit
	  mozilla_1_0
	  mozilla_1_1
	  openssl
	  perl_5
	  qpl_1_0
	  ssleay
	  sun
	  zlib
	  open_source
	  restricted
	  unrestricted
	  unknown

また、以前の[`Module::Build`](http://search.cpan.org/dist/Module-Build/)と互換性を保つために、以下の指定が可能です。

    apache	     	->「apache_2_0」がメタファイルへ出力
    artistic		->「artistic_1」がメタファイルへ出力
    artistic2		->「artistic_2」がメタファイルへ出力
    gpl		     	->「open_source」がメタファイルへ出力
    lgpl 			->「open_source」がメタファイルへ出力
    mozilla			->「open_source」がメタファイルへ出力
    perl 			->「perl_5」がメタファイルへ出力
    restrictive		->「restricted」がメタファイルへ出力


加えて、MYMETA.ymlと、META.yml (meta-spec v1.4) では、仕様に合わせて以下の様にコンバートされます。

	  agpl_3            -> open_source
	  apache_1_1        -> apache
	  apache_2_0        -> apache
	  artistic_1        -> artistic
	  artistic_2        -> artistic_2
	  bsd               -> bsd
	  freebsd           -> open_source
	  gfdl_1_2          -> open_source
	  gfdl_1_3          -> open_source
	  gpl_1             -> gpl
	  gpl_2             -> gpl
	  gpl_3             -> gpl
	  lgpl_2_1          -> lgpl
	  lgpl_3_0          -> lgpl
	  mit               -> mit
	  mozilla_1_0       -> mozilla
	  mozilla_1_1       -> mozilla
	  openssl           -> open_source
	  perl_5            -> perl
	  qpl_1_0           -> open_source
	  ssleay            -> open_source
	  sun               -> open_source
	  zlib              -> open_source
	  open_source       -> open_source
	  restricted        -> restrictive
	  unrestricted      -> unrestricted
	  unknown           -> unknown

### ExtUtils::MakeMaker

[`ExtUtils::MakeMaker`](http://search.cpan.org/dist/ExtUtils-MakeMaker/)は、`Makefile.PL`に指定されたlicenseをそのまま[`CPAN::Meta::Spec`](http://search.cpan.org/dist/CPAN-Meta/)に渡してメタファイルを作成します。

しかし、`Artistic_2_0`というライセンスの名前は無いので、結果的に`unknown`になってしまうわけです。

正しくは、`artistic_2 `を指定すべきですね。

### Module::Build

`Module::Build`は、少々複雑です。`Module::Build`は内部でライセンスの一覧を持っていて、かつ[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされているかによって挙動が変わります。

[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされていなくても指定可能なライセンスの一覧は以下の通りです。

    perl
    apache
    apache_1_1
    artistic
    artistic_2
    lgpl
    bsd
    gpl
    mit
    mozilla
    restrictive
    open_source
    unrestricted
    unknown

以下の4つは、[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされていないとメタファイルを作成する時にエラーになります。

    lgpl2
    lgpl3
    gpl2
    gpl3

しかし、[`CPAN::Meta::Spec`](http://search.cpan.org/dist/CPAN-Meta/)でのライセンス名と異なるので、メタファイルには違う文字列が出力されます(`gpl3 -> gpl_3 `など)。

以下のライセンス名は、[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされている時だけ有効です。別名ですね。「`Perl_5`」が`Module::Build`では、[`Software::License`](http://search.cpan.org/dist/Software-License/)がインストールされていないと指定できないって所は少しトラップです。

    Perl_5
    Apache_2_0
    Artistic_1_0
    Artistic_2_0
    LGPL_2_1
    LGPL_3_0
    GPL_1
    GPL_2
    GPL_3
    Mozilla_1_1
    Restricted

その他、Software::Licenseがインストールされている時だけ有効なラインセスです。

    CC0_1_0
    Mozilla_2_0
    PostgreSQL

[`CPAN::Meta::Spec`](http://search.cpan.org/dist/CPAN-Meta/)には該当するライセンス名が無いので、`open_source`などに置き換えられます。つまり、ExtUtils::MakeMakerでは指定できないという事です。

## おわりに

CPANにアップロードするなら、[`CPAN::Meta::Spec`](http://search.cpan.org/dist/CPAN-Meta/)がサポートするライセンスが良いようです。

