Enbldの内部構造を解説するシリーズ、第四回目です。

自分で作っておいて言うのもあれですが、無駄に複雑ですね。

[Enbldの内部構造 - その1](../archives/inner_enbld_1.html)

[Enbldの内部構造 - その2](../archives/inner_enbld_2.html)

[Enbldの内部構造 - その3](../archives/inner_enbld_3.html)


## Definitionモジュールを実際に作る

初回に紹介したGNU HelloのDefinitionモジュールは非常にシンプルでしたが、GNU以外はなかなか一筋縄ではいきません。

今回は、tmuxのDefinitionモジュールを例に紹介します。

	package Enbld::Definition::Tmux;

	use 5.012;
	use warnings;

	use parent qw/Enbld::Definition/;

	sub initialize {
		my $self = shift;

		$self->SUPER::initialize;

		$self->{defined}{AdditionalArgument}   =  \&set_argument;
		$self->{defined}{ArchiveName}       =   'tmux';
		$self->{defined}{WebSite}           =   'http://tmux.sourceforge.net';
		$self->{defined}{VersionForm}       =   '\d\.\d';
		$self->{defined}{Dependencies}      =   [ 'pkgconfig', 'libevent' ];
		$self->{defined}{DownloadSite}      =
			'http://sourceforge.net/projects/tmux/files/tmux/';

		$self->{defined}{IndexParserForm}   =   \&set_index_parser_form;
		$self->{defined}{URL}               =   \&set_URL;

		$self->{defined}{CommandConfigure}  =   'sh configure';
		$self->{defined}{CommandMake}       =   'make';
		$self->{defined}{CommandTest}       =   'make test';
		$self->{defined}{CommandInstall}    =   'make install';

		return $self;
	}

	sub set_argument {

		require Enbld::Home;
		my $path = File::Spec->catdir(
				Enbld::Home->install_path,
				'lib',
				'pkgconfig'
				);

		my $env = 'PKG_CONFIG_PATH=' . $path;

		return $env;
	}

	sub set_index_parser_form {
		my $attributes = shift;

		my $index_form = quotemeta( $attributes->ArchiveName ) . '-' .
					$attributes->VersionForm;

		my $index_parser_form = '<a href="/projects/tmux/files/tmux/' .
			$index_form . '/stats/timeline"';

		return $index_parser_form;
	}

	sub set_URL {
		my $attributes = shift;

		my $dir  = $attributes->ArchiveName . '-' . $attributes->Version;
		my $file = $attributes->ArchiveName . '-' . $attributes->Version .
			'.' . $attributes->Extension;

		my $url = $attributes->DownloadSite . $dir . '/' . $file . '/download';

		return $url;
	}

	1;

一つ一つ解説していきます。

### パッケージ名

    package Enbld::Definition::Tmux;


パッケージ名は、必ず`Enbld::Definition`を継承し、大文字で始めます。

enbldではターゲットソフトウェアの検索をパッケージ名で行っています(`enblder available`で出てくるリストはこのパッケージ名を出力しています）。そのため、パッケージ名はソフトウェアの名前を表し、かつperlのパッケージ名の制約に合わせてつけてください（使える文字とか）。

### Enbld::Definitionモジュールの継承

    use parent qw/Enbld::Definition/;

`Definitionモジュール`は、`Enbld::Definition`を継承します。

### initializeメソッド

Enbld::Definitionをnewすると、引数に指定されたターゲットソフトウェア名をパッケージ名としてオブジェクトの生成を行います。その際、子クラスのinitializeメソッドが呼ばれます。

    $self->SUPER::initialize;

親クラスのinitializeメソッドを呼び出しています…が、今は実は何もしていません。将来に向けた拡張性確保のためです。

### Attributeの初期化

    $self->{defined}{IndexSite} =
        'http://sourceforge.net/projects/tmux/files/tmux/';


前回解説した様に、Attributeが返す値をセットしています。

    $self->{defined}{URL} = \&set_URL;

tmuxのダウンロードサイトは、バージョンごとにサブディレクトリが切られているため(あと、なぜか末尾にdownloadという文字もくっつきます)、単純に`'DonwloadSite'+'Filename'`という形では正しいURLを生成することができません。

そのため、`set_URL`という関数のコードリファレンスを渡して独自にURLを生成しています。

	sub set_URL {
		my $attributes = shift;

		my $dir  = $attributes->ArchiveName . '-' . $attributes->Version;
		my $file = $attributes->ArchiveName . '-' . $attributes->Version .
			'.' . $attributes->Extension;

		my $url = $attributes->DownloadSite . $dir . '/' . $file . '/download';

		return $url;
	}

中身は単純ですが、引数で受け取っている`$attributes`がポイントです。

Definitionモジュールでコードリファレンスが設定されていると、引数として、`Enbld::Target::AttributeCollector`のオブジェクトが引き渡されます。このオブジェクトを経由することで他のAttributeを参照することができるようになっているわけです。

## おわりに

駆け足で紹介してきましたが、Attribute間の関係が複雑なので、ちょっと分かりづらいですが、なるべく典型的な構成であれば、最小限の内容でビルドできるようになっているのが分かるかと思います。

ぜひ新しいDefinitionモジュールを作ってみてください。

