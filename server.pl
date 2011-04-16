#!/usr/bin/env perl 
#===============================================================================
#
#         FILE:  server.pl
#
#        USAGE:  ./server.pl  
#
#  DESCRIPTION:  Creates a new server instance for communicating with libnotify.
#
# REQUIREMENTS:  Desktop::Notify, IO::Socket, IO::Select.
#       AUTHOR:  Alexandria M. Wolcott <alyx@sporksmoo.net> 
#      VERSION:  1.0
#      CREATED:  04/15/2011 05:51:30 PM
#===============================================================================

package Irssi::Notify::Server;

use strict;
use warnings;
use base 'Net::Server';
use Desktop::Notify;

my $notify = Desktop::Notify->new();

sub process_request {
    my $self = shift;
    my $notification;
    while (<STDIN>) {
        s/\r?\n$//;
        $notification = $notify->create(summary => 'New IRC highlight!',
                                        body => $_,
                                        timeout => 20000);
    }
    $notification->show;
    sleep 3;
    $notification->close;
}

Irssi::Notify::Server->run(port => 48620);
