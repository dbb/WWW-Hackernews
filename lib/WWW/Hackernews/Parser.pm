package WWW::Hackernews::Parser;

use strict;
use warnings;

use base 'Exporter';
our @EXPORT = qw( hn_parse );

use version;
our $VERSION = qv( '0.1' );

sub hn_parse {

    my $targ = shift // 'top';
    my $num  = shift // '1';
    my $what = shift // 'all';

    my $data = {};

    use LWP::Simple;
    my $html =
        ( $targ =~ /new/i )
        ? get( 'http://news.ycombinator.com/newest' )
        : get( 'http://news.ycombinator.com' );

    unless ( $html ) {
        warn "Could not download data from ycombinator.com";
        return 0;
    }

    if (
        $html =~ m{
    >\s*$num\.</td>\s*<td>\s*<center>\s*<a\s+id=up_
    (\d+) # $1 -> id
    \s+href="vote\?for=\g1&dir=up&whence=[%a-e0-9]+">\s*<img\s+src="http://yc
    ombinator\.com/images/grayarrow\.gif"\s+border=\d+\s+vspace=\d+\s+hspace=
    \d+>\s*</a>\s*<span\s+id=down_\g1>\s*</span>\s*</center>\s*</td>\s*<td\s+
    class="title">\s*<a\s+href="
    ([^"]+) # $2 -> uri
    ">
    ([^<]+) # $3 -> desc
    </a>\s*<span\s*class="comhead">\s*\(
    ([\w\.]+) # $4 -> dom
    \)\s*</span>\s*</td>\s*</tr>\s*<tr>\s*<td\s+colspan=\d+>\s*</td>\s*<td\s+
    class="subtext">\s*<span\s+id=score_\g1>
    (\d+) # $5 -> score
    \s+point(s)?\s*</span>\s+by\s+<a\s+href="user\?id=
    ([^"]+) # $7 -> user
    ">\g7</a>\s*
    (\d+) # $8 -> age_qty
    \s+
    (hour|minute) # $9 age_unit
    (s)?\s+ago\s+\|\s*<a\s+href="item\?id=\g1">\s*
    (\d+) # $11 -> comments
    \s+comment(s)?\s*</a>
        }ix
        )
    {

        $data->{ 'id' }       = $1;
        $data->{ 'uri' }      = $2;
        $data->{ 'desc' }     = $3;
        $data->{ 'dom' }      = $4;
        $data->{ 'score' }    = $5;
        $data->{ 'user' }     = $7;
        $data->{ 'age_qty' }  = $8;
        $data->{ 'age_unit' } = $9;
        $data->{ 'comments' } = $11;

        # for debugging purposes
        $data->{'pattern'} = 1;


    } ## end if ( $html =~ m{ ) (})
    elsif (
        $html =~ m{
    >\s*$num\.</td>\s*<td>\s*<center>\s*<a\s+id=up_
    (\d+) # $1 id
    \s+href="vote\?for=\g1&dir=up&whence=[%a-e0-9]+">\s*<img\s+src="http://yc
    ombinator\.com/images/grayarrow\.gif"\s+
    border=\d+
    \s+vspace=
    \d+\s+hspace=
    \d+>\s*</a>
    \s*<span\s+id=down_\g1></span>\s*</center>\s*</td>\s*<td\s+class="title">
    \s*<a\s+href="
    ([^"]+) # $2 uri
    "\s+rel="nofollow">
    ([^<]+) # $3 desc
    </a>\s*<span\s+class="comhead">\s*\(
    ([^)]+) # $4 dom
    \)\s*</span>\s*</td>\s*</tr>\s*<tr>\s*<td\s+colspan=\d+>\s*</td>\s*<td\s+
    class="subtext">\s*<span\s+id=score_\g1>
    (\d+) # $5 score
    \s+point(s)?\s*</span>\s*by\s+<a\s+href="user\?id=
    ([^"]+) # $7 user
    ">\g7</a>\s*
    (\d+) # $8 age_qty
    \s+
    (hour|minute) # $9 age_unit
    (s)\s+ago\s+\|\s*<a\s+href="item\?id=\g1">\s*discuss\s*</a>
        }imx
        )
    {

        $data->{ 'id' }       = $1;
        $data->{ 'uri' }      = $2;
        $data->{ 'desc' }     = $3;
        $data->{ 'dom' }      = $4;
        $data->{ 'score' }    = $5;
        $data->{ 'user' }     = $7;
        $data->{ 'age_qty' }  = $8;
        $data->{ 'age_unit' } = $9;
        $data->{ 'comments' } = 0;

        # for debugging purposes
        $data->{'pattern'} = 2;
    } ## end elsif ( $html =~ m{ )  [ if ( $html =~ m{ ) (})](})

    elsif (
        $html =~ m{
        >\s*$num\.\s*</td>\s*<td>\s*</td>\s*<td\s+class="title">\s*<a\s+href="
        item\?id=
        (\d+) # $1 id
        ">
        ([^<]+) # $2 desc
        </a>\s*</td>\s*</tr>\s*<tr>\s*<td\s+colspan=\d+>\s*</td>\s*<td\s+clas
        s="subtext">\s*
        (\d+) # $3 age_qty
        \s+
        (hour|minute)(s)? # $4 age_unit
        \s+ago\s*</td>
        }imx
        )
    {

        $data->{ 'id' }       = $1;
        $data->{ 'uri' }      = 'http://news.ycombinator.com/item?id=' . $1;
        $data->{ 'dom' }      = 'ycombinator.com';
        $data->{ 'desc' }     = $2;
        $data->{ 'age_qty' }  = $3;
        $data->{ 'age_unit' } = $4;

        # for debugging purposes
        $data->{'pattern'} = 3;
    } ## end elsif ( $html =~ m{ )  [ if ( $html =~ m{ ) (})](})

    else {
        warn "Unable to match pattern";
        return 0;
    }

    if ( $what =~ /all/i ) {
        return $data;
    }
    elsif ( $data->{ $what } ) {
        return $data->{ $what };
    }
    else {
        warn "Can't return '$what'; returning all";
        return $data;
    }


} ## end sub hn_parse

1;

__END__

=pod

=head1 NAME

B<Hackernews::Parser> - a Perl interface to Hackernews (L<http://news.ycombinator.com/>) stories and data

=head1 SYNOPSIS

    use WWW::Hackernews::Parser;
    
    my $top_hash_ref = hn_parse( 'top', '1' );
    # equivalent to:
    my $other_top_hash_ref = hn_parse();

    my $second_newest = hn_parse( 'new', '2' );

=head1 DEPENDENCIES

=over 4

=item * B<perl> - version 5.10 or above

=item * B<LWP::Simple> - Debian package: libwww-perl

=back

=head1 DESCRIPTION

The only subroutine of B<WWW::Hackernews::Parser> is B<hn_parse>. It takes the following arguments:

=over 4

=item 1. B<target> - This is what page to download the data from; is either C<top> or C<new>. Defaults to C<top>.

=item 2. B<number> - This is the rank of the story. C<1> is the top story, and so on. Defaults to C<1>.

=item 3. B<datum> - This is the name of the datum and hash key to be return (list follows. The default is C<all>, which returns the hash ref as a scalar.

=back

The subroutine stores data in an anonymous hash that may contain any of the following keys, depending on what the pattern was able to match:

=over 4

=item * B<age_qty> - the numercal value of the age

=item * B<age_unit> - either C<hour(s)> or C<minute(s)>

=item * B<age_sec> - age in seconds calculated by the above

=item * B<comments> - number of comments

=item * B<desc> - description

=item * B<domain> - the domain on which the link is hosted

=item * B<id> - the unique numerical identification number of the link

=item * B<score> - the "karma" level of the link, or number of points

=item * B<user> - the name of the user who posted the link

=back

=head1 SEE ALSO

L<perldoc>, L<LWP::Simple>

=head1 COPYRIGHT

Copyright 2011 Daniel Bolton.

Permission is granted to copy, distribute and/or modify this 
document under the terms of the GNU Free Documentation 
License, Version 3.0 or any later version published by the 
Free Software Foundation; with no Invariant Sections, with 
no Front-Cover Texts, and with no Back-Cover Texts.

=cut
