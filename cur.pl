use OpenRitsPen;

#
# WASDで移動
#

use strict;
use warnings;

use constant BUFFSIZE => 256;
use constant WAIT => 20;

my @list;
my $angle = 0;
my $penangle = 0;
my $x = 350;
my $y = 250;
my $speed = 1;
my $RitsPen = new OpenRitsPen();
my $save_state=`stty -g`;
system("stty -echo -icanon");
    my $pen = $RitsPen->CreatePEN("Perl Tron");
    $RitsPen->ChangeSpeed($pen, $speed);
while((my $c = getc(STDIN)) ne "q"){
    $angle=90 if ($c eq "w");
    $angle=180 if ($c eq "a");
    $angle=270 if ($c eq "s");
    $angle=0 if ($c eq "d");
    $list[$x][$y] = 1;
    select undef, undef, undef, WAIT / 1000;
    $RitsPen->UsePEN($pen, $speed, $penangle - $angle);
    $penangle = $angle;
}
system("stty '$save_state'");
