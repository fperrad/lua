#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaZlib

=head2 Synopsis

    % perl t/zlib.t

=head2 Description

Tests LuaZlib
(implemented in F<languages/lua/src/lib/zlib.pir>).

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 1;
use Test::More;
use Parrot::Test::Lua;

language_output_is( 'lua', << 'CODE', << 'OUT', 'require zlib' );
require "zlib"
print(type(zlib))
print(zlib._VERSION)
CODE
table
LuaZlib 1.0.0
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

