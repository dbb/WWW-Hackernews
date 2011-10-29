use Module::Build;
my $build = Module::Build->new(
    module_name => 'WWW:Hackernews::Parser',
    dist_abstract => 'Extract data from Hackernews',
    dist_author => 'Daniel Bolton <dbb008@gmail.com>',
    license => 'gpl',
    requires => { LWP::Simple => 0.42 },
    recommends => {},
    build_requires => {Test::Pod => 0,
		       Test::Pod::Coverage => 0,
		       Module::Build => 0},

    create_makefile_pl => 'passthrough'
    );
$build->create_build_script;
