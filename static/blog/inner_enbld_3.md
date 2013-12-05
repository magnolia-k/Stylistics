Enbldの内部解説、3回目です。

過去の記事はこちらから。

[Enbldの内部構造 - その1](../archives/inner_enbld_1.html)

[Enbldの内部構造 - その2](../archives/inner_enbld_2.html)

## Attributeモジュール

今回はAttributeモジュールを解説します。

### AdditionalArgument

configureに渡す追加パラメータを返すAttributeです。

デフォルトは、`undef`です。
### ArchiveName.pm

ソースコードのアーカイブファイルのファイル名を返すAttributeです。

未設定だと例外を送出します。
### CommandConfigure

ターゲットのMakefileを生成するコマンドを返すAttributeです。

デフォルトは、`'./configure'`です。
### CommandInstall

ターゲットをインストールするコマンドを返すAttributeです。

デフォルトは、`'make install'`です。
### CommandMake.pm

ターゲットをビルドするコマンドを返すAttributeです。

デフォルトは、`'make'`です。
### CommandTest

ターゲットをテストするコマンドを返すAttributeです。

デフォルトは、`'make check'`です。
### Dependencies

ターゲットをインストールするために必要なターゲットを返すAttributeです。

ターゲット名の配列のリファレンスを返します。

デフォルトは、`undef`です。
### DownloadSite

ソースコードのダウンロードサイトのURLを返すAttributeです。

未設定だと例外を送出します。
### Extension

ソースコードのアーカイブファイルの拡張子を返すAttributeです。

デフォルトでは、`'tar.gz'`を返します。
### Filename

ソースコードのファイル名を返すAttributeです。

デフォルトでは、`'ArchiveName'-'Version'.'Extension'`を返します。
### IndexParserForm

ダウンロードサイトのHTMLをパースするための正規表現を返すAttributeです。

デフォルトでは、「`<a href="'ArchiveName'-'VersionForm'\.'Extension'">`」です。
### IndexSiteターゲットのバージョンナンバーを取得するサイトのURLを返すAttributeです。

ターゲットによっては、ダウンロードサイトと、インデックスを取得するサイトが異なる場合が有ります(gitとか）。その様なソフトウェアのために用意されているAttributeです。

デフォルトでは、`'DownloadSite'`をそのまま返します。### SortedVersionListソート済みのバージョンナンバーを返すAttributeです。バージョンナンバーの配列へのリファレンスを返します。ソート対象のバージョンナンバーの一覧は`'VersionList'`から取得します。### URLソースコードのアーカイブファイルを指すURLを返すAttrbiuteです。

デフォルトでは、`'DownloadSite''ArchiveName'-'Version'.'Extension'`です。
### Versionターゲットのバージョンを返すAttributeです。

VersionConditionが、実際のバージョンナンバーの時は、その値を返します。

VersionConditionが、'latest'の場合は`SortedVersionList`から最も大きなバージョンナンバーを返します。### VersionConditionユーザーが指定したバージョンの条件を返すAttributeです。### VersionFormターゲットソフトウェアのバージョンにマッチする正規表現を返すAttributeです。未設定だと例外を送出します。
### VersionListバージョンナンバーの一覧を返すAttributeです。

バージョンナンバーの配列へのリファレンスを返します。

このAttributeがEnbldの一番のキモです。

具体的には、`'IndexSite'`から取得したHTMLを`'IndexParser'`でパースした結果が収録されます。
### WebSite

ターゲットソフトウェアのオフィシャルサイトのURLを返すAttributeです。

未設定だと例外を送出します。


## 次回は、具体的なdefinitionモジュールの例を