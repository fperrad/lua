#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Lua Operating System Library

=head2 Synopsis

    % parrot t/libos.t

=head2 Description

Wrapper for t/lua-TestMore/test_lua51/308-os.t

=cut

.sub 'main'
    $I0 = spawnw 'parrot lua.pbc t/lua-TestMore/test_lua51/308-os.t'
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
