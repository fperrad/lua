#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Lua table & coercion

=head2 Synopsis

    % parrot t/table.t

=head2 Description

Wrapper for t/lua-TestMore/test_lua51/106-table.t

=cut

.sub 'main'
    $I0 = spawnw 'parrot lua.pbc t/lua-TestMore/test_lua51/106-table.t'
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
