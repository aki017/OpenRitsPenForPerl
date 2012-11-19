package OpenRitsPen;

=head1 NAME

OpenRitsPen - OpenRitsPen

=head1 DESCRIPTION


=cut

# ----------------------------------------------------------------------

use strict;

use Socket;

use constant USE_PEN        => 0;
use constant CHANGE_COLOR   => 1;
use constant CHANGE_COLOR2  => 2;
use constant CHANGE_WIDTH   => 3;
use constant CHANGE_SPEED   => 4;
use constant CREATE_PEN     => 5;
use constant CHANGE_PEN_TOP => 6;
use constant CLOSE_PEN      => 7;

sub new{
    my $pkg = shift;
    bless {}, $pkg;
}
sub ChangePenTop{
    my $self = shift;
    if ( @_ ) {
        my ($pen, $pt) = @_;
        
        $self->_send($pen , undef, undef, CHANGE_PEN_TOP);
        $self->ChangeColor($pen,$pt->color);
        $self->ChangeWidth($pen,$pt->width);
        $self->ChangeSpeed($pen,$pt->speed);
    }
}
sub CreatePEN{
    my $self = shift;
    if ( @_ ) {
        my ( $name ) = @_;
        my $sock;
        socket( $sock, PF_INET, SOCK_STREAM, getprotobyname('tcp' ) )or die "Cannot create socket: $!";
        connect( $sock , sockaddr_in( 4242, inet_aton("localhost"))) or die "Cannot connect Server: $!"; 
        $name =~ s/:/_/g;
        $self->_send($sock, $name, undef, CREATE_PEN);
        return $sock;
    }
    return -1;
}

sub ClosePEN{
    my $self = shift;
    if ( @_ ) {
        my ( $sock ) = @_;
        $self->_send($sock, undef, undef, CLOSE_PEN);
        close($sock);
    }
}

sub UsePEN{
    my $self = shift;
    if ( @_ ) {
        my ( $sock, $size, $angle ) = @_;
        $self->_send($sock, $size, $angle, USE_PEN);
    }
}

sub ChangeColor{
    my $self = shift;
    if ( @_ ) {
        my ( $sock, $color ) = @_;
        # Cの実装ではundefではなく$color
        $self->_send($sock, revise($color, 8), undef, USE_PEN);
    }
}

sub revise{
    my ($x, $y) = @_;
    $x = abs($x);
    return $x%$y;
}

sub ChangeColor2{
    my $self = shift;
    if ( @_ ) {
        my ( $sock, $r, $g, $b ) = @_;
        # Cの実装ではundefではなく$color
        $self->_send($sock, sprintf("%d;%d;%d",revise($r,255),revise($g,255),revise($b,255) ), undef, CHANGE_COLOR2);
    }
}

sub ChangeWidth{
    my $self = shift;
    if ( @_ ) {
        my ( $sock, $size ) = @_;
        $size = revise($size, 8);
        $self->_send($sock, $size, undef, CHANGE_WIDTH);
    }
}

sub ChangeSpeed{
    my $self = shift;
    if ( @_ ) {
        my ( $sock, $speed ) = @_;
        $self->_send($sock, abs($speed), undef, CHANGE_SPEED);
    }
}

sub _send{
    my $self = shift;
    my $sock = shift;
    my $arg1 = shift || "0";
    my $arg2 = shift || "0";
    my $order = shift || 0;
    send($sock, sprintf("%s:%s:%d\n", $arg1, $arg2, $order), 0)
}

1;
