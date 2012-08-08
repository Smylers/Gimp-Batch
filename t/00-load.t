#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Gimp::Batch' ) || print "Bail out!\n";
}

diag( "Testing Gimp::Batch $Gimp::Batch::VERSION, Perl $], $^X" );
