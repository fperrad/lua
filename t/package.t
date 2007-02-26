#! perl
# Copyright (C) 2007, The Perl Foundation.
# $Id: package.t $

=head1 NAME

t/package.t - Lua Package Library

=head1 SYNOPSIS

    % perl -I../lib -Ilua/t lua/t/package.t

=head1 DESCRIPTION

Tests Lua Package Library
(implemented in F<languages/lua/lib/luapackage.pir>).

See "Lua 5.1 Reference Manual", section 5.3 "Modules",
L<http://www.lua.org/manual/5.1/manual.html#5.3>.

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Parrot::Test tests => 7;
use Test::More;

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'function require' );
local m = require "io"
m.write("hello world\n")
CODE
hello world
OUTPUT

unlink('../complex.lua') if ( -f '../complex.lua' );
my $X;
open $X, '>', '../complex.lua';
print {$X} << 'CODE';

complex = {}

function complex.new (r, i) return {r=r, i=i} end

--defines a constant 'i'
complex.i = complex.new(0, 1)

function complex.add (c1, c2)
    return complex.new(c1.r + c2.r, c1.i + c2.i)
end

function complex.sub (c1, c2)
    return complex.new(c1.r - c2.r, c1.i - c2.i)
end

function complex.mul (c1, c2)
    return complex.new(c1.r*c2.r - c1.i*c2.i,
                       c1.r*c2.i + c1.i*c2.r)
end

local function inv (c)
    local n = c.r^2 + c.i^2
    return complex.new(c.r/n, -c.i/n)
end

function complex.div (c1, c2)
    return complex.mul(c1, inv(c2))
end

return complex
CODE
close $X;

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'function require' );
m = require "complex"
assert(m == complex)
print(complex.i.r, complex.i.i)
CODE
0	1
OUTPUT

language_output_like( 'lua', << 'CODE', << 'OUTPUT', 'function require (no module)' );
require "no_module"
CODE
/module 'no_module' not found:\n/
OUTPUT

unlink('../foo.lua') if ( -f '../foo.lua' );
open $X, '>', '../foo.lua';
print {$X} '?syntax error?';
close $X;

language_output_like( 'lua', << 'CODE', << 'OUTPUT', 'function require (syntax error)');
require "foo"
CODE
/error loading module 'foo' from file '.*foo.lua':\n/
OUTPUT

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'table package.loaded' );
t = {}
for k in pairs(package.loaded) do
    table.insert(t, k)
end
table.sort(t)
for k, v in ipairs(t) do
    print(v)
end
CODE
_G
coroutine
debug
io
math
os
package
string
table
OUTPUT

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'table package.path' );
print(type(package.path))
CODE
string
OUTPUT

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'table package.preload' );
print(type(package.preload))
print(# package.preload)
CODE
table
0
OUTPUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

