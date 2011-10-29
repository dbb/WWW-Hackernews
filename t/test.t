use strict;
use Test;

# First check that the module loads OK.
use vars qw($loaded);
BEGIN {  $| = 1;  plan tests => 4; }
END {print "not ok 1\n" unless $loaded;}

use WWW::Hackernews::Parser;
print "! Testing module load ...\n";
ok(++$loaded); # 1

my $default_hr = hn_parse();
ok( $default_hr ); # 2

# args: (new|top) (\d+) (\w+)
#       target    num   key
my $new_hr = hn_parse( 'new' );
ok( $new_hr ); # 3

my $top_second_user = hn_parse( 'top', '2', 'user' );
ok( $top_second_user ); # 4

