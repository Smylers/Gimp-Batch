use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Gimp::Batch',
    AUTHOR              => q{Smylers <smylers@cpan.org>},
    VERSION_FROM        => 'lib/Gimp/Batch.pm',
    ABSTRACT_FROM       => 'lib/Gimp/Batch.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Gimp-Batch-*' },
);
