#! perl
# Copyright (C) 2006-2009, Parrot Foundation.
# $Id$

=head1 Lua userdata & coercion

=head2 Synopsis

    % perl t/userdata.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 24;
use Test::More;

language_output_like( 'lua', <<'CODE', <<'OUT', '- u' );
local u = io.stdin
print(- u)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', '# u' );
local u = io.stdin
print(# u)
CODE
/^[^:]+: (\w:)?[^:]+:-?\d+: attempt to get length of/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'not u' );
local u = io.stdin
print(not u)
CODE
false
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u + 10' );
local u = io.stdin
print(u + 10)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u - 2' );
local u = io.stdin
print(u - 2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u * 3.14' );
local u = io.stdin
print(u * 3.14)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u / -7' );
local u = io.stdin
print(u / -7)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u % 4' );
local u = io.stdin
print(u % 4)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u ^ 3' );
local u = io.stdin
print(u ^ 3)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u .. "end"' );
local u = io.stdin
print(u .. "end")
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to concatenate/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'u == u' );
local u = io.stdin
print(u == u)
CODE
true
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'u ~= v' );
local u = io.stdin
local v = io.stdout
print(u ~= v)
CODE
true
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'u == 1' );
local u = io.stdin
print(u == 1)
CODE
false
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'u ~= 1' );
local u = io.stdin
print(u ~= 1)
CODE
true
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u < v' );
local u = io.stdin
local v = io.stdout
print(u < v)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two userdata values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u <= v' );
local u = io.stdin
local v = io.stdout
print(u <= v)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two userdata values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u > v' );
local u = io.stdin
local v = io.stdout
print(u > v)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two userdata values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u >= v' );
local u = io.stdin
local v = io.stdout
print(u >= v)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two userdata values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u < 0' );
local u = io.stdin
print(u < 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u <= 0' );
local u = io.stdin
print(u <= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u > 0' );
local u = io.stdin
print(u > 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'u >= 0' );
local u = io.stdin
print(u >= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'get_pmc_keyed' );
local u = io.stdin
print(u[1])
CODE
nil
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'set_pmc_keyed' );
local u = io.stdin
u[1] = 1
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to index/
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

