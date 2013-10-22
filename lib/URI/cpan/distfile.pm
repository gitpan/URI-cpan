use strict;
use warnings;

package URI::cpan::distfile;
{
  $URI::cpan::distfile::VERSION = '1.005';
}
use parent qw(URI::cpan);
# ABSTRACT: cpan:///distfile/AUTHOR/Dist-1.234.tar.gz

use Carp ();
use CPAN::DistnameInfo;


sub validate {
  my ($self) = @_;

  my (undef, undef, $author, $filename) = split m{/}, $self->path, 4;

  Carp::croak "invalid cpan URI: invalid author part in $self"
    unless $author =~ m{\A[A-Z][-0-9A-Z]*\z};
}


sub dist_name {
  my ($self) = @_;
  my $dist = CPAN::DistnameInfo->new($self->_p_rel);
  my $name = $dist->dist;

  $name =~ s/-undef$// if ! defined $dist->version;

  return $name;
}


sub dist_version {
  my ($self) = @_;
  CPAN::DistnameInfo->new($self->_p_rel)->version;
}


sub author {
  my ($self) = @_;
  my ($author) = $self->_p_rel =~ m{^([A-Z]+)/};
  return $author;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

URI::cpan::distfile - cpan:///distfile/AUTHOR/Dist-1.234.tar.gz

=head1 VERSION

version 1.005

=head1 SYNOPSIS

This URL refers to a file in an author directory on the CPAN, and expects the
format AUTHOR/DISTFILE

=head1 METHODS

=head1 dist_name

This returns the name of the dist, like F<CGI.pm> or F<Acme-Drunk>.

=head1 dist_version

This returns the version of the dist, or undef if the version can't be found or
is the string "undef"

=head1 author

This returns the name of the author whose file is referred to.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
