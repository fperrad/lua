#! perl
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/src/yapp";

use Getopt::Std;
use Lua::parser;

my %opts;
getopts( 'hv', \%opts );
if ( $opts{v} ) {
    print "$0\n";
    print "Perl $] on $^O\n";
    exit;
}
if ( $opts{h} or scalar(@ARGV) != 1 ) {
    use Pod::Usage;
    pod2usage( -verbose => 1 );
}

my $parser = new Lua::parser();
$parser->YYData->{verbose_error}   = 1;    # 0, 1
$parser->YYData->{verbose_warning} = 1;    # 0, 1
$parser->YYData->{verbose_info}    = 1;    # 0, 1
$parser->Run(@ARGV);

if ( exists $parser->YYData->{nb_error} ) {
    my $nb = $parser->YYData->{nb_error};
    print "$nb error(s).\n";
}
if ( $parser->YYData->{verbose_warning}
    and exists $parser->YYData->{nb_warning} )
{
    my $nb = $parser->YYData->{nb_warning};
    print "$nb warning(s).\n";
}
if ( $parser->YYData->{verbose_info}
    and exists $parser->YYData->{nb_info} )
{
    my $nb = $parser->YYData->{nb_info};
    print "$nb info(s).\n";
}

unless ( exists $parser->YYData->{nb_error} ) {
    $parser->Generate();
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

__END__

=head1 Lua compiler

=head2 Synopsis

 luac [options] I<source>.lua

=head2 Options

=over 8

=item B<-h>

Display help.

=item B<-v>

Display version.

=back

=head2 Description

=cut

