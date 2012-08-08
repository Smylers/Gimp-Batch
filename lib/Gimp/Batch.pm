package Gimp::Batch;

use warnings;
use strict;

use v5.10;
use autodie;
use Exporter qw<import>;

use Scalar::Util qw<blessed reftype>;

use Gimp::Batch::Scheme;


=head1 NAME

Gimp::Batch - Batch-process images with The Gimp

our $VERSION = '0.01';


=head1 SYNOPSIS

 use Gimp::Batch;

=cut


sub new
{
  my ($class, @cmd) = @_;

  my $self = bless {}, $class;

  $self->step(@cmd);

  $self;
}


our @EXPORT_OK = qw<fn image drawable TRUE FALSE>;
our %EXPORT_TAGS = (all => \@EXPORT_OK);


sub image { Gimp::Batch::Scheme->new('image') };
sub drawable { Gimp::Batch::Scheme->new('drawable') };
sub TRUE { Gimp::Batch::Scheme->new('TRUE') };
sub FALSE { Gimp::Batch::Scheme->new('FALSE') };


sub fn
{
  my ($fn, @arg) = @_;

  $fn =~ s/_/-/g;

  # Quote string args:
  foreach (@arg)
  {

    # That is, an argument which isn't already Scheme syntax and which behaves
    # like a string rather than a number:
    no warnings qw<numeric>;
    if (!(blessed $_ && $_->isa('Gimp::Batch::Scheme')) && ($_ & '') eq '')
    {
      $_ = qq["$_"];
      # TODO Find out what Scheme's quote-escaping syntax is.
    }
  }
  
  Gimp::Batch::Scheme->new("($fn @arg)");
}


sub step
{
  my ($self, @cmd) = @_;

  no warnings qw<uninitialized>;
  if (reftype $cmd[0] eq 'ARRAY')
  {
    $self->step(@$_) foreach @cmd;
  }

  else
  {
    push @{$self->{cmd}}, fn @cmd;
  }

  $self;
}


sub apply
{
  my ($self, $in_file, $out_file) = @_;

  $out_file //= $in_file;

  # TODO Allow specifying alternative program path.
  # TODO Allow specifying alternative options.
  open $self->{gimp_handle}, '|-', 'gimp-console -db -'
      unless $self->{gimp_handle};

  print { $self->{gimp_handle} } <<EOT;
(
  let*
  (
    (image (car (gimp-file-load RUN-NONINTERACTIVE "$in_file" "$in_file")))
    (drawable (car (gimp-image-get-active-layer image)))
  )
  @{$self->{cmd}}
  (set! drawable (car (gimp-image-get-active-layer image)))
  (gimp-file-save RUN-NONINTERACTIVE image drawable "$out_file" "$out_file")
  (gimp-image-delete image)
)
EOT

}


sub DESTROY
{
  my ($self) = @_;

  if ($self->{gimp_handle})
  {
    print { $self->{gimp_handle} } q[(gimp-quit TRUE)];
    close $self->{gimp_handle};
  }

}


=head1 AUTHOR

Smylers, C<< <smylers at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Smylers.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;
