use OpenRitsPen;
use GD::Image;

use strict;
use warnings;

if($#ARGV != 0){
    print "usage : ./image.pl filename \n";
    exit 0;
}
my $file = $ARGV[0];
my $RitsPen = new OpenRitsPen();
my $pen = $RitsPen->CreatePEN("Perl Image");
$RitsPen->UsePEN($pen, 1, );

my $width = 620;
my $height = 700;
my $gdold = GD::Image->new($file);
my ($iw, $ih) = $gdold->getBounds();
if ($iw/$ih > $width/$height){
    $height = int($height * $iw / $width) ;
}else{
    $width = int($width * $ih / $height) ;
}
my $gd = new GD::Image($width, $height, 1);
$gd->copyResized( $gdold,  0,  0,  0,  0,  $width,  $height,  $iw,  $ih );
($iw, $ih) = $gd->getBounds();
    $RitsPen->ChangeWidth($pen, 0);
    $RitsPen->ChangeSpeed($pen, 0);
    $RitsPen->UsePEN($pen, 350, -180);
    $RitsPen->UsePEN($pen, 310, 90);
    $RitsPen->UsePEN($pen, 0, 90);
    $RitsPen->ChangeWidth($pen, 1);
for my $i (0..($height-1)){
    for my $j (0..($width-1)){
        my ($r, $g, $b) = $gd->rgb($gd->getPixel($j, $i));
        $RitsPen->ChangeColor2($pen, $r, $g, $b);
        $RitsPen->UsePEN($pen, 1, 0);
    }
    $RitsPen->ChangeWidth($pen, 0);
    $RitsPen->UsePEN($pen, $width, 180);
    $RitsPen->UsePEN($pen, 1, -90);
    $RitsPen->UsePEN($pen, 1, 90);
    $RitsPen->UsePEN($pen, 1, -180);
    $RitsPen->ChangeWidth($pen, 1);
}
