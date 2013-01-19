use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'File::Stamped::Extended',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/File/Stamped/Extended.pm',
    build_requires      => {
        'Test::More' => 0.88,
    },
    requires => {
        'perl' => '5.8.1',
        'POSIX' => 0,
        'File::Stamped' => 0.02,
    },
    add_to_cleanup      => [ 'File-Stamped-Extended-*' ],
    meta_merge     => {
      resources => {
        repository  => 'http://github.com/bayashi/File-Stamped-Extended'
      }
    },
    recursive_test_files => 1,
);

$builder->create_build_script();
