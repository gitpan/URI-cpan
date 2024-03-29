use strict;
use warnings;

package URI::cpan::module;
{
  $URI::cpan::module::VERSION = '1.005';
}
use parent qw(URI::cpan);

sub validate { die }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

URI::cpan::module

=head1 VERSION

version 1.005

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
