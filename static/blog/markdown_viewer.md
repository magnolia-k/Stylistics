# Markdown viewerを書いた

　Markdownでそれなりの量の文章を書くことになったので、簡単なMarkdown Viewerを作った。

　素直にmattnさんの[`mkup`](https://github.com/mattn/mkup)を使えば普通に解決だけど、Perlでも似たようなものが作れないかと、書いてみた。

[https://github.com/mattn/mkup](https://github.com/mattn/mkup)

AnyEventベースで、[Twiggy](http://search.cpan.org/dist/Twiggy/lib/Twiggy.pm)と、[Plack::App::WebSocket](http://search.cpan.org/~toshioito/Plack-App-WebSocket/lib/Plack/App/WebSocket.pm)と、[AnyEvent::Filesys::Notify](http://search.cpan.org/dist/AnyEvent-Filesys-Notify/lib/AnyEvent/Filesys/Notify.pm)を組み合わせた。

　WebSocketを使うのが初めてだったので色々な実装を試したけど、結局最初のアクセスはhttpベースなので、通常のhttpアクセスと、WebSocketの両方に対応しようとするとAnyEventベースでPlackでまとめた方が全然簡単だった。

    my $notifier = AnyEvent::Filesys::Notify->new(
        dirs    => [ $dirs ],
        filter  => sub { shift =~ /$file$/ },
        cb      => sub {
            my ( @events ) = @_;

            for my $event ( @events ) {
                if ( $event->is_modified ) {
                    open my $fh, '<', $event->path or die $!;
                    my $md = read_file( $event->path );
                    close $fh;
                    if ( exists $connection{$watch_path} ) {
                        $connection{$watch_path}->send( markdown( $md ));
                    }

こんな感じで、WebSocketのコネクションを保持しておいて、ファイルの更新を検知したらhtmlに変換したmarkdownを送り込む。

　一方、javascript側では、受け取ったメッセージをそのままhtmlに突っ込んでいるだけ。

    function onMessage(event) {
        var content = document.getElementById('content');
        while (content.firstChild) content.removeChild(content.firstChild);

        content.innerHTML = event.data;
    }

　残念ながら`Text::Markdon`しか使っていないので、現状ではGitHub FlavoredなMarkdownには対応していないのと、コードハイライトも未対応です。

