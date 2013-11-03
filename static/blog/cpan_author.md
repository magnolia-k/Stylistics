CPAN Authorになるまでの手順は、いくつかブログで紹介されていますが、ちょっと最近だったら補足しておいた方がいい所が有るので、2013年版ということで整理してみました。

# 1.PAUSEでアカウント登録

## 1.1.申請

CPANにファイルをアップするために[PAUSE](https://pause.perl.org/pause/query)でアカウントを登録する必要が有ります。

[https://pause.perl.org/pause/query](https://pause.perl.org/pause/query)の画面左上の[Request PAUSE account](https://pause.perl.org/pause/query?ACTION=request_id)をクリックすると、登録画面が出てきます。

名前、メールアドレス、Web Site（オプション）、希望するID、PAUSEに登録しようと思った理由を簡単に書いて「Request Account」ボタンを押します。

IDの一覧は、[CPANのAuthor](http://search.cpan.org/author/)から見ることが出来ます。

申請の内容はメーリングリストに投げられるので、[module@perl.orgのアーカイブ](http://www.nntp.perl.org/group/perl.modules/)で全て公開されますので、記載内容は慎重に。予めほかの人の申請内容を見ておくといいと思います。

### 1.1.1.気をつける点

- 名前

 名前は公開されますので、慎重に。

- ID

 CPANは、作者のIDのアルファベット順に階層が作られるので、こちらも慎重に。

- 登録理由

 何書けばいいのかよく分からなかったので、とりあえずGitHubへのリンクを張って、「perlのモジュール書いたから！」って書きました。

- 返信までの時間

 管理者による承認プロセスがちゃんと入るので、ボタンを押してから返信のメールが来るまで早くても4〜5時間はかかります。

 数日かかることも有るみたいなので、気長に待ちましょう。

- 確認メール

 ボタン押すとすぐに送られてくるメールにリンクが張られていて慌てて押したくなりますが、管理者以外は押せないリンクですので、気をつけましょう（よくメール本文を読めば分かるんですが...）

 管理者宛の申請メールのccが申請者に送られているだけです。

## 1.2.登録

管理者による承認が完了すると、メールが2通送られて来ます。

 - 一通目は、アカウント登録完了に関するメールです。

 - 二通目は、仮パスワードが書かれたメールです。

一通目にパスワードを変更するページへのリンクが張られているので、すぐに変えましょう。

あと、一通目の最後に、「モジュールは、いきなりアップするんじゃなくて、事前に[PrePAN](http://prepan.org/)でレビュー受けた方がいいよって書かれているので、それに従った方が良いでしょう。

私も事前に[PrePAN](http://prepan.org/)に登録しました。

あと、Mac OS Xのメーラーが問答無用で迷惑メールに振り分けていたので、危うく見落とす所でした。皆さんもメールが来ないな、と思った時は迷惑メールフィルタを疑いましょう。

## 1.3.アカウント情報の編集

パスワードが発行されてログインできる様になったら、アカウント情報を登録します。

### Full Name
申請した名前が入っていますが、変更することができます。

漢字で登録した場合は、次の「ASCII transliteration of Full Name
」にローマ字読みを登録しましょう。

### email address

email addressは公開されるパブリックなものと、公開されないプライベートなものを登録することができます。

公開用のアドレスを持っていない人でも、「【登録したID】@cpan.org」という転送専用のアドレスが発行されるので、そちらを公開用に使うことができます。

最後にcpan.orgをどっちのメールアドレスに転送するか？って選択できるラジオボタンが有るので、選んでおきましょう。

# 2. モジュールのアップロード

モジュールのアップロードは、画面左のメニュー「Upload a file to CPAN」から行います。

ローカルドライブに置かれたファイルを選択するか、URL指定でアップロードします。

ファイル転送に成功すると、すぐにメールが送られてきます。

しばらくすると、アーカイブファイルの内容をインデックスに登録したよってメールが来ます。

## 2.1.アップロードの確認

[CPANのRecent](http://search.cpan.org/recent)に表示されるまでには、2〜3時間かかりますので、気長に待ちましょう。

でも、[metacpanのRecent](https://metacpan.org/recent)にはすぐ表示されますので、こちらを見ればちゃんとアップできたか分かるので、安心です。

# 3. META.json

最近は皆さんリポジトリはGitHubを使っていると思うので、Issue登録はGitHub側で行いたいですね。

そんな時は、META.jsonの「resources」属性をちゃんと設定しておく必要があります。

[ExtUtils::MakeMaker](http://search.cpan.org/dist/ExtUtils-MakeMaker/)だったら、META_MERGE属性で追加することができます。

[Enbld](http://search.cpan.org/dist/Enbld/)のMETA.jsonは、こんな感じの設定になっています。

	"resources" : {
	  "bugtracker" : {
		 "web" : "https://github.com/magnolia-k/Enbld/issues"
	  },
	  "homepage" : "https://github.com/magnolia-k/Enbld",
	  "repository" : {
		 "type" : "git",
		 "url" : "https://github.com/magnolia-k/Enbld.git",
		 "web" : "https://github.com/magnolia-k/Enbld"
	  }
	},

Makefile.PLはこんな感じです。meta-specのバージョンを2に設定しないと正しく反映されないので気をつけましょう。

	META_MERGE		=> {
		"meta-spec" => { version => 2 },
	
		"no_index" => {
			"directory" => [ "xt" ]
		},
	
		"resources" => {
			"homepage" => "https://github.com/magnolia-k/Enbld",
	
			"bugtracker" => {
				"web" => "https://github.com/magnolia-k/Enbld/issues",
			},
	
			"repository" => {
				"type" => "git",
				"url"  => "https://github.com/magnolia-k/Enbld.git",
				"web"  => "https://github.com/magnolia-k/Enbld",
			},
		},
	},

特にissueは、必ず欲しいので、`bugtracker`は忘れずに。

`no_index`あたりもちゃんと設定した方が良いので、ちゃんとチェックしておきましょう。

## 3.1. その他
あとは何もともあれ、[http://www.cpan.org/modules/04pause.html](http://www.cpan.org/modules/04pause.html)を全部チェックしておきましょう。

[CPAN::Meta::Spec](http://search.cpan.org/~dagolden/CPAN-Meta-2.132830/lib/CPAN/Meta/Spec.pm)は一通り読んでおくといいでしょう。

# 4. Gravatarへの登録

CPANや、Metacpanで独自のアイコンを設定するには、[Gravatar](http://ja.gravatar.com)を使います。メールアドレスを「【アカウント】@cpan.org」で登録すると、そのアイコンが自動的にCPANやMetacpanで表示されます。

GitHubとかと同じアイコンにしておくと、いいと思います。

以上、CPANにモジュールをアップするまでの流れでした。

つまり言いたかったのは、metacpan重要！CPAN::Meta重要！って事です。

