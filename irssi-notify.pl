use Irssi;
use IO::Socket;
use vars qw($VERSION %IRSSI); 
$VERSION = "0.1";
%IRSSI = (
    authors         => 'Alexandria M. Wolcott',
    contact         => 'alyx@sporksmoo.net',
    name            => 'notify-highlight',
    description     => 'Show hilight messages in libnotify bubble',
    license         => 'GNU GPLv2',
    changed         => "Fri Apr 15 11:19:42 CST 2011"

);

sub notify {
    my ($text) = @_;
    my $sock = IO::Socket::INET->new(
        PeerAddr => 'localhost',
        PeerPort => 48620,
        Timeout => 5
    );
    print $sock "$text\r\n";
    close $sock;
}

sub handle_text {
    my ($dest, $text, $stripped) = @_;

    my $window = Irssi::active_win();

    if (($dest->{level} & MSGLEVEL_HILIGHT) && ($dest->{level} & MSGLEVEL_PUBLIC) && 
        ($window->{refnum} != $dest->{window}->{refnum}) && ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0) {

        $text = $dest->{target}.": ".$stripped;
        notify $text;
    }
}

sub handle_kick {
     my ($server, $chan, $nick, $knick, $address, $reason) = @_;
     my $win = Irssi::active_win();
     my $kchan = $server->window_find_item($chan);
 
     return if $win->{refnum} == $kchan->{refnum} || $server->{nick} ne $nick;
    notify("You were kicked from $chan by $knick for: $reason");
     $kchan->activity(4);
 }

Irssi::signal_add('print text', 'handle_text');
Irssi::signal_add('message kick', 'handle_kick');
