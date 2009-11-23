#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Lua Table Library

=head2 Synopsis

    % parrot t/libtable.t

=head2 Description

Wrapper for t/lua-TestMore/test_lua51/305-table.t

=cut

.sub 'main'
    $I0 = spawnw 'parrot lua.pbc t/lua-TestMore/test_lua51/305-table.t'
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
