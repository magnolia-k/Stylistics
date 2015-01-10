年末に「[Programming Scala 2nd Edition](http://shop.oreilly.com/product/0636920033073.do)」を入手してscalaの書き方ばかり勉強していました。

インストールから、テストコードを書いて、カバレッジを取得するところまでたどり着いたので、そのメモです。

Mac OS X Yosemiteで検証しました。

# Scalaのインストール

## JVMのインストール

ScalaはJVM(Java Virtual Machine)上で動作する言語なので、まずはJDK(Java Development Kit)をインストールします。

[OracleのJavaダウンロードサイト](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

2015/1/3現在ではJava SE 8u25が最新です。

## Scalaのインストール

[公式サイト](http://www.scala-lang.org)のダウンロードリンクからアーカイブファイルをダウンロードします。

[Scalaのダウンロードサイト](http://www.scala-lang.org/download/)

一番上に、安定版リリースへのリンクが有りますので、それをクリックすれば、ダウンロードがスタートします。

ダウンロードしたアーカイブファイルを解凍して、適当な場所に配置します。「bin」とか、「man」とかのディレクトリが有るので、PATHやMANPATHを通します。

# Scalaの起動
何の引数も付けずに`scala`コマンドを起動するとREPLという対話型の実行環境が起動します。


    $ scala
    Welcome to Scala version 2.11.4 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_25).
    Type in expressions to have them evaluated.
    Type :help for more information.

    scala> println("Hello, Scala")
    Hello, Scala

「scala >」というコマンドプロンプトに続けてscalaのコードを書けばすぐに実行されるので、学習やコードスニペットの実行に使います。

# 実行

## コンパイルと実行

Scalaは、Javaと同じ様に事前にコンパイルして、実行ファイルを作成します。ソースコードの拡張子は、「.scala」です。

以下のソースコードを「HelloScala.scala」という名前で保存します。

    package HelloScala
    
    object Main {
      def main(args: Array[String]) {
        println("Hello, Scala!")
      }
    }

コンパイルには「scalac」コマンドを使います。  

    $ scalac HelloScala.scala
    $

エラーが無ければ何も表示されずにコンパイルが終わります。

`HelloScala`というディレクトリの中に、「HelloScala.class」「HelloScala$.class」という二つのファイルが出来ているはずです。

    $ ls HelloScala
    HelloScala$.class	HelloScala.class

実行には、「scala」コマンドを使います。引数には「パッケージ名.'`main`関数が定義されている`object`の名称'」を指定します。

    $ scala HelloScala.Main
    Hello, Scala!

パッケージ名を指定するのがちょっと面倒ですね。

## コンパイルなしで実行

スクリプト言語っぽく、いきなり実行したいコードをずらずらと書いておけば、事前のコンパイルなしで実行することもできます。

    println("Hello, Scala!")

「scala」コマンドで実行します。

    $ scala HelleScalaScript.scala
    Hello, Scala!

shebangも使えます。

    #!/usr/bin/env scala
    println("Hello, Scala!")

実行権限を付与して実行します。

    $ chmod +x HelloScalaShebang.scala
    $ ./HelloScalaShebang.scala
    Hello, Scala!

コマンドライン引数も取れます。

    #!/usr/bin/env scala
    println("Hello, " + args(0))

実行権限を付与して、引数を渡して実行します。

    $ chmod +x HelloAny.scala
    $ ./HelloAny.scala scala!
    Hello, scala!
    $ ./HelloAny.scala perl!
    Hello, perl!

起動時間も気にならないくらいの速さです。

# vimの設定

vim用の設定は、以前はScalaの配布ファイルに各種エディタの設定も含まれていたらしいですが、最近は含まれなくなったので、Scalaの公式リポジトリに残っているファイルを取得します（オリジナルの配布元もリンク切れになっていますし…）。

[https://github.com/scala/scala-dist/tree/master/tool-support/src/vim](https://github.com/scala/scala-dist/tree/master/tool-support/src/vim)

まとめて、「.vim」ディレクトリ配下へコピーします。

scalaでは、タブ設定はスペース2つ分がよく使われると言うことで、`$HOME/.vim/ftdetect/scala.vim`に以下の設定を追加。

    au FileType scala set smartindent expandtab tabstop=2 shiftwidth=2 softtabstop=2

# sbtのインストール

次に、scala用のビルドツールである[sbt](http://www.scala-sbt.org)をインストールします。

インストールパッケージもありますが、今回は手動でインストールします。以下のサイトからアーカイブファイルをダウンロードします。

[sbt - Download](http://www.scala-sbt.org/download.html)

解凍すると、`bin`と`conf`というディレクトリが出来るので、scala本体と同じ場所にコピーするだけです。

# 終わりに
これでインストール完了です。次は、sbtを使ったビルド方法を説明します。
