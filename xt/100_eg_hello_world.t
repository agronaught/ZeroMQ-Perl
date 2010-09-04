use strict;
use Test::More;
use Test::TCP;
BEGIN {
    use_ok "ZeroMQ", qw(ZMQ_REQ ZMQ_REP);
}

test_tcp(
    client => sub {
        my $port = shift;
        my $ctxt = ZeroMQ::Context->new();
        my $sock = $ctxt->socket(ZMQ_REQ);
        $sock->connect( "tcp://127.0.0.1:$port" );
        $sock->send("hello");

        my $message = $sock->recv();
        is $message->data, "world", "client receives correct data";
    },
    server => sub {
        my $port = shift;
        my $ctxt = ZeroMQ::Context->new();
        my $sock = $ctxt->socket(ZMQ_REP);
        $sock->bind( "tcp://127.0.0.1:$port" );

        my $message = $sock->recv();
        is $message->data, "hello", "server receives correct data";
        $sock->send("world");
    }
);

done_testing;