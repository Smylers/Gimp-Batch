package Gimp::Batch::Scheme;

=head1 NAME

Gimp::Batch::Scheme - A snippet of Scheme used by Gimp::Batch

=cut

use warnings;
use strict;

use Exporter qw<import>;

use overload '""' => \&_stringify;


sub new
{
  my ($class, $text) = @_;

  bless \$text, $class;
}


sub _stringify
{
  my ($self) = @_;

  $$self;
}


1;
