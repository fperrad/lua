#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown library

=head2 Synopsis

    % perl t/markdown.t

=head2 Description

Tests Markdown
(implemented in F<languages/lua/src/lib/markdown.pir>).

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test;
use Test::More;
use Parrot::Test::Lua;

my $test_prog = Parrot::Test::Lua::get_test_prog();
if ( $test_prog eq 'lua' ) {
    plan skip_all => "parrot only";
}
elsif (! -f "$FindBin::Bin/../../../languages/markdown/markdown.pbc") {
    plan skip_all => "markdown.pbc not available";
}
else {
    plan tests => 2;
}

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'require' );
local m = require "markdown"
print(type(m))
CODE
table
OUTPUT

language_output_is( 'lua', << 'CODE', << 'OUTPUT', 'markdown' );
require "markdown"

local html = markdown.markdown [=[
# Title

Some text.

]=]

print(html)
CODE
<h1>Title</h1>

<p>Some text.</p>

OUTPUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
