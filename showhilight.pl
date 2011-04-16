# Print hilighted messages with MSGLEVEL_PUBLIC  to active window 
# for irssi 0.7.99 by Pawe³ 'Styx' Chuchma³a based on hilightwin.pl by Timo Sirainen
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

sub sig_printtext {
  my ($dest, $text, $stripped) = @_;

  my $window = Irssi::active_win();

  if (($dest->{level} & MSGLEVEL_HILIGHT) && ($dest->{level} & MSGLEVEL_PUBLIC) && 
       ($window->{refnum} != $dest->{window}->{refnum}) && ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0) {

    $text = $dest->{target}.": ".$stripped;

    my $sock = IO::Socket::INET->new(
        PeerAddr => 'localhost',
        PeerPort => 48620,
        Timeout => 5
   );
    print $sock "$text\r\n";
    close $sock;
  }
}

Irssi::signal_add('print text', 'sig_printtext');
