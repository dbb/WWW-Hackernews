use inc::Module::Install;
#use Module::Install::ExtraTests;

# Define metadata
name           'WWW-Hackernews-Parser';
perl_version   '5.010';
version        '0.01';
license        'perl';

# Specific dependencies
test_requires  'LWP::Simple'  => '0.42';

# Testing
#extra_tests;

WriteAll;

