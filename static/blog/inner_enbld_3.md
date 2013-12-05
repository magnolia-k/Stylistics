Enbldの内部解説、3回目です。

過去の記事はこちらから。

[Enbldの内部構造 - その1](../archives/inner_enbld_1.html)

[Enbldの内部構造 - その2](../archives/inner_enbld_2.html)

## Attributeモジュール

今回はAttributeモジュールを解説します。

### AdditionalArgument

configureに渡す追加パラメータを返すAttributeです。

デフォルトは、`undef`です。


ソースコードのアーカイブファイルのファイル名を返すAttributeです。

未設定だと例外を送出します。


ターゲットのMakefileを生成するコマンドを返すAttributeです。

デフォルトは、`'./configure'`です。


ターゲットをインストールするコマンドを返すAttributeです。

デフォルトは、`'make install'`です。


ターゲットをビルドするコマンドを返すAttributeです。

デフォルトは、`'make'`です。


ターゲットをテストするコマンドを返すAttributeです。

デフォルトは、`'make check'`です。


ターゲットをインストールするために必要なターゲットを返すAttributeです。

ターゲット名の配列のリファレンスを返します。

デフォルトは、`undef`です。


ソースコードのダウンロードサイトのURLを返すAttributeです。

未設定だと例外を送出します。


ソースコードのアーカイブファイルの拡張子を返すAttributeです。

デフォルトでは、`'tar.gz'`を返します。


ソースコードのファイル名を返すAttributeです。

デフォルトでは、`'ArchiveName'-'Version'.'Extension'`を返します。


ダウンロードサイトのHTMLをパースするための正規表現を返すAttributeです。

デフォルトでは、「`<a href="'ArchiveName'-'VersionForm'\.'Extension'">`」です。


ターゲットによっては、ダウンロードサイトと、インデックスを取得するサイトが異なる場合が有ります(gitとか）。その様なソフトウェアのために用意されているAttributeです。

デフォルトでは、`'DownloadSite'`をそのまま返します。

デフォルトでは、`'DownloadSite''ArchiveName'-'Version'.'Extension'`です。


VersionConditionが、実際のバージョンナンバーの時は、その値を返します。

VersionConditionが、'latest'の場合は`SortedVersionList`から最も大きなバージョンナンバーを返します。


バージョンナンバーの配列へのリファレンスを返します。

このAttributeがEnbldの一番のキモです。

具体的には、`'IndexSite'`から取得したHTMLを`'IndexParser'`でパースした結果が収録されます。


ターゲットソフトウェアのオフィシャルサイトのURLを返すAttributeです。

未設定だと例外を送出します。


## 次回は、具体的なdefinitionモジュールの例を