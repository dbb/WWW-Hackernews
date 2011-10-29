# NAME

**WWW::Hackernews::Parser** - a Perl interface to [Hackernews](http://news.ycombinator.com/) stories and data.

# SYNOPSIS

    use Hackernews::Parser;

    my $top_hash_ref = hn_parse( 'top', '1' );
    # equivalent to:
    my $other_top_hash_ref = hn_parse();

    my $second_newest = hn_parse( 'new', '2' );

# DEPENDENCIES


* **perl** - version 5.10 or above

* **LWP::Simple** - Debian package: [libwww-perl](http://packages.debian.org/stable/libwww-perl)


# DESCRIPTION

The only subroutine of `Hackernews::Parser` is `hn_parse`. It takes the following arguments:

1. **target** - This is what page to download the data from; is either `top` or `new`. Defaults to `top`.

2. **number** - This is the rank of the story. `1` is the top story, and so on. Defaults to `1`.

3. **datum** - This is the name of the datum and hash key to be returned (list follows). The default is `all`, which returns the hash ref as a scalar.

Note: the arguments are shifted _in the order listed above_. That means if you want to pass a number, you must also pass a target. Likewise, if you want to pass a hash key, you must pass a target **and** a number before it.

The subroutine stores data in an anonymous hash that may contain any of the following keys, depending on what the pattern was able to match:

* **age\_qty** - the numercal value of the age

* **age\_unit** - either hour(s)or minute(s)

* **age\_sec** - age in seconds calculated by the above

* **comments** - number of comments

* **desc** - description

* **domain** - the domain on which the link is hosted

* **id** - the unique numerical identification number of the link

* **points** - the "karma" level of the link

* **user** - the name of the user who posted the link

# SEE ALSO

[perldoc](http://perldoc.perl.org/perldoc.html), LWP::Simple

# COPYRIGHT

Copyright 2011 Daniel Bolton.

Permission is granted to copy, distribute and/or modify this 
document under the terms of the GNU Free Documentation 
License, Version 3.0 or any later version published by the 
Free Software Foundation; with no Invariant Sections, with 
no Front-Cover Texts, and with no Back-Cover Texts.

# THANKS

I would like to give thanks to [telemachus](https://github.com/telemachus), [tornow](https://github.com/tornow), and [initself](http://blogs.perl.org/users/initself/) for helping me with this project.

# BUGS

If you find a bug, file an issue on the project's Github page. If you have code to contribute, fork the repository and file a pull request. The URI is:

<https://github.com/dbb/Hackernews-Parser/>

