前回はEnbldのAttributeを紹介しました。今回は、Attributeの生成方法を説明します。

## Attributeの生成

Attributeは、4種類の生成方法が有ります。

 - Definitionモジュール
 - Attributeモジュール
 - VersionCondition
 - 他のAttributeの組み合わせ

順に説明していきます。

### Definitionモジュールから

Definitionモジュールで定義された内容が返却されます。

    require Enbld::Definition;
    my $attributes = Enbld::Definition->new( 'hello' )->parse;
    $attributes->ArchiveName # -> hello

`Enbld::Definition::Hello`モジュールの中身を見てみましょう。

    $self->{defined}{ArchiveName} = 'hello';

`Enbld::Definition::Hello`モジュールの中で定義された内容がそのまま返却されています。

Definitionモジュールの引数はコードリファレンスもokです。

    $self->{defined}{ArchiveName} = sub { return 'hello' };

各Attributeには返却値のバリデーション機能が備わっていて、Attributeを参照する際に評価されるようになっています。

なので、不正な値を返すと実行時に例外を送出します。

    # in definition module
    $self->{defined}{ArchiveName} = sub { return };

    # get attribute value
    $attributes->ArchiveName;	# -> throw exception

### VersionConditionから

VersionConditionは利用者側が設定した内容が引き継がれます。

DSLの中で設定したversion関数の引数がそのまま設定されます。明示的に設定しない時は、デフォルトで'latest'が設定されます。

    target 'git' => define {
        version '1.8.5;    # -> set attribute 'VersionCondition' to '1.8.5'
    }

    target 'perl' => define {
        version 'latest';    # -> set attribute 'VersionCondition' to 'latest'
    }


### Attributeモジュールから

Extension(アーカイブファイルの拡張子)というAttributeは、特にDefinitionモジュールの中で設定しない時は、デフォルトで`tar.gz`を返します。

この挙動は、`Enbld::Target::Attribute::Extension`モジュールの中で定義しています。

	sub initialize {
		my ( $self, $param ) = @_;

		if ( ! defined $param ) {
			$self->{value} = 'tar.gz';
			$self->{is_evaluated}++;

			return $self;
		}

      ...

`initializeメソッド`のパラメータに何も値が設定されていないと、`tar.gz`が設定されているのが分かっていただけると思います。

Versionはその名の通り、バージョンナンバーを返すAttributeですが、VersionConditionの値によってバージョンの内容は変わります。

DSLでバージョンナンバーが指定されていれば、その値をそのまま返します。'latest'が指定されている時は、IndexSiteというAttributeで得られるURLへアクセスし、最新バージョンのバージョンナンバーを取得し、返します。バージョンを特定する仕組みの詳細はまた別途解説します（Enbldの一番のキモなので）。

    target 'git' => define {
        version '1.8.5;    # -> Attribute 'Version' returns '1.8.5'
    }

    target 'perl' => define {
        version 'latest';    # -> Attribute 'Version' returns '5.18.1' at 2013-12-4
    }


### 他のAttributeの組み合わせから

典型的なオープンソースソフトのアーカイブファイルのファイル名は、最初に説明した通り'[アーカイブ名]-[バージョンナンバー].tar.gz'という形式になっています。

なので、FilenameというAttributeは、ArchiveName、Version、Extensionという３つのAttributeを組み合わせて生成します。

`Enbld::Attribute::Filename`の初期化コードは以下の通りです。


	sub initialize {
		my ( $self, $param ) = @_;

		if ( ! defined $param ) {
			$self->{callback} = sub {
				my $attributes = shift;

				my $filename = $attributes->ArchiveName . "-";
				$filename .= $attributes->Version . '.' . $attributes->Extension;

				return $filename;
			};

特にDefinitionモジュール側で何も設定していなければ、３つのAttributeを組み合わせて生成しているのが分かると思います。

特殊なファイル名構造を持つソフトであれば、Definitionモジュールの中でファイル名を組み立てるコードリファレンスを渡して初期化すればOKです。

例えば、Libeventはいちいち安定版を表す「stable」という単語がファイル名に含まれているので、以下の様なコードでファイル名を生成しています。

    {
         $self->{defined}{Filename}          =   \&set_filename;
    };

    	sub set_filename {
		my $attributes = shift;

		my $filename = $attributes->ArchiveName . '-' . $attributes->Version .
			'-stable.' . $attributes->Extension;

		return $filename;
	}

## 次回は…

今回はここまで。

次回は、各Attributeの解説です。