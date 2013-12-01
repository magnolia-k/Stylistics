以前からずっとリクエストをもらっていたEnbldの内部構造に関する記事です。

ようやく書き始めました。

[Enbld](http://search.cpan.org/dist/Enbld/)のDefinitionモジュールを書く人向けです。

## Definitionモジュールとは?

Enbldでは、ターゲットのソフトウェアごとに「Definitionモジュール」を用意します。

例えば、[GNU Hello](http://www.gnu.org/software/hello/)というシンプルなソフトウェアが有りますが、HelloのDefinitionモジュールは以下の通りになっています。

	package Enbld::Definition::Hello;

	use 5.012;
	use warnings;

	use parent qw/Enbld::Definition/;

	sub initialize {
		my $self = shift;

		$self->SUPER::initialize;

        $self->{defined}{WebSite}      = 'http://www.gnu.org/software/hello/';

        $self->{defined}{DownloadSite} = 'http://ftp.gnu.org/gnu/hello/';
        $self->{defined}{ArchiveName}  = 'hello';
        $self->{defined}{VersionForm}  = '\d\.\d';

        return $self;
	}

	1;

詳細はのちほど解説しますが、ポイントは$self->{defined}というハッシュリファレンスにビルドに必要な情報を設定している点です。

Helloでは、'WebSite'、'DownloadSite'、'ArchiveName'、'VersionForm'という4つのキーを設定しています。


    $self->{defined}{WebSite}      = 'http://www.gnu.org/software/hello/';

    $self->{defined}{DownloadSite} = 'http://ftp.gnu.org/gnu/hello/';
    $self->{defined}{ArchiveName}  = 'hello';
    $self->{defined}{VersionForm}  = '\d\.\d';


'WebSite'は単にavailableコマンドで表示する情報をセットしているだけなので、実際にはビルドでは使いません。

ビルドする際に使っている情報は、残る'DownloadSite'と、'ArchiveName'、'VersionForm'の三つだけです。

 - DownloadSite

  ソースコードのダウンロードサイトのURLです。
  
  ブラウザでアクセスすると分かりますが、過去のバージョンも含めたHelloのソースコードのアーカイブファイルの一覧と、そのファイルへのリンクが表示されます。

 - ArchiveName

  上記のDownloadSiteの表示を見れば分かると思いますが、アーカイブファイルのファイル名です。

 - VersionForm

  Helloのバージョンナンバー部分に合致する正規表現です。

  このバージョンナンバーに合致する正規表現こそが、Enbldの一番重要なポイントです。あとでこれが活躍するところがいっぱい出てきますので、お楽しみに。

さて、ではなぜこの情報だけでビルド出来るのでしょう？

### 一般的なオープンソースソフトウェアを構成する4つのポイント

Enbldでは「一般的なオープンソースソフトウェア構成」に従ったソフトであればこの情報だけでビルドが出来るようになっています。

では、Enbldが前提としている「一般的なオープンソースソフトウェア構成」とは何でしょう？

それは以下の以下の4つです。

 - ビルド手順は、`./configure -> make -> make install`の3ステップ
 - ソースコードアーカイブファイルのファイル名形式は、'[アーカイブ名]-[バージョンナンバー].tar.gz'
  
  例: hello-2.9.tar.gz

 - ソースコードは、配布用サイトのディレクトリに過去バージョンも含めて全てまとめて格納されている。

   例:http://ftp.gnu.org/gnu/hello/

 - バージョンナンバーは数値のみで構成されていて「x.xx」「x.x.x」といったピリオドで区切られた形式で、単純にソートすることが可能

  例: 2.7 -> 2.8 -> 2.9

ただし、上記の4つの流儀から外れるソフトウェアでもDefinitionモジュールの中で$self->{defined}に必要な情報を追加すれば、対応可能な様になっています(当然Definitionモジュールの記述量はその分増えます)。

## Attribute

Enbldの内部では、Definitionモジュールから生成されたAttribute(属性)というオブジェクトを使ってビルドに必要な情報を取り出していきます。つまり、DefinitionモジュールはAttributeを生成するための「ひな形」にあたります。

Attributeには以下のものが用意されています。

 - AdditionalArgument
 - AllowedCondition
 - ArchiveName
 - CopyFiles
 - Dependencies
 - DistName
 - DownloadSite
 - Extension
 - Filename
 - IndexParserForm
 - IndexSite
 - PatchFiles
 - Prefix
 - URL
 - SortedVersionList
 - Version
 - VersionList
 - VersionCondition
 - VersionForm
 - WebSite
 - CommandConfigure
 - CommandMake
 - CommandTest
 - CommandInstall

Attributeの参照は以下の様に、Attributeの名前と同じメソッド名で行います。

        require Enbld::Definition;

        my $attributes   = Enbld::Definition->new( 'hello' )->parse;
        my $archive_name = $attributes->ArchiveName; # $archive_name -> 'hello'

Attributeに設定されている内容をまとめて見たい時は、`chkenbld`というコマンドを使います。

    $ chkenbld hello

これでずらっと表示される中身を見てもらえると、だいたいどんな内容がAttributeで取得できるか、分かってもらえると思います。

では次回は、実際のソフトウェアのビルドの流れと、Attributeの使われ方（生成のされ方）を見ていきましょう。