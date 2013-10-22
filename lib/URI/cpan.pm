use strict;
use warnings;
# ABSTRACT: URLs that refer to things on the CPAN

package URI::cpan;
{
  $URI::cpan::VERSION = '1.005';
}
use parent qw(URI::_generic);


use Carp ();
use URI::cpan::author;
use URI::cpan::dist;
use URI::cpan::distfile;
use URI::cpan::module;
use URI::cpan::package;
use URI::cpan::dist;

my %type_class = (
  author   => 'URI::cpan::author',
  distfile => 'URI::cpan::distfile',

  # These will be uncommented when we figure out what the heck to do with them.
  # -- rjbs, 2009-03-30
  #
  # dist    => 'URI::cpan::dist',
  # package => 'URI::cpan::package',
  # module  => 'URI::cpan::module',
);

sub _init {
  my $self = shift->SUPER::_init(@_);
  my $class = ref($self);

  # In the future, we'll want to support "private" CPAN.  Probably when that
  # happens we will want to assert $self->authority eq $self->host.
  # -- rjbs, 2009-03-29
  Carp::croak "invalid cpan URI: non-empty authority not yet supported"
    if $self->authority;

  Carp::croak "invalid cpan URI: non-empty query string not supported"
    if $self->query;

  Carp::croak "invalid cpan URI: non-empty fragment string not supported"
    if $self->fragment;

  my (undef, @path_parts) = split m{/}, $self->path;
  my $type = $path_parts[0];

  Carp::croak "invalid cpan URI: do not understand path " . $self->path
    unless my $new_class = $type_class{ $type };

  bless $self => $new_class;

  $self->validate;

  return $self;
}

sub _p_rel {
  my ($self) = @_;
  my $path = $self->path;
  $path =~ s{^/\w+/}{};
  return $path;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

URI::cpan - URLs that refer to things on the CPAN

=head1 VERSION

version 1.005

=head1 SYNOPSIS

  use URI::cpan;

  my $uri = URI->new('cpan:///distfile/RJBS/URI-cpan-1.000.tar.gz');

  $uri->author;       # => RJBS
  $uri->dist_name;    # => URI-cpan
  $uri->dist_version; # => 1.000

Other forms of cpan: URI include:

  cpan:///author/RJBS

Reserved for likely future use are:

  cpan:///dist
  cpan:///module
  cpan:///package

=head1 WARNINGS

URI objects are difficult to subclass, so I have not (yet?) taken the time to
remove mutability from the objects.  This means that you can probably alter a
URI::cpan object into a state where it is no longer valid.

Please don't change the contents of these objects after construction.

=head1 SEE ALSO

L<URI::cpan::author> and L<URI::cpan::distfile>

=head1 THANKS

This code is derived from code written at Pobox.com by Hans Dieter Pearcey.
Dieter helped thrash out this new implementation, too.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
