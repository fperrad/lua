#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaUserdata

=head2 Synopsis

    % parrot t/pmc/userdata_hll.t

=head2 Description

Tests C<userdata> type
(implemented in F<languages/lua/src/pmc/luauserdata.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(6)

    check_HLL()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    $P0 = new 'LuaUserdata'
    $P1 = new 'Array'
    setattribute $P0, 'data', $P1
    $I0 = isa $P0, 'LuaUserdata'
    ok($I0, "check HLL")
.end

.sub 'check_tostring'
    $P0 = new 'LuaUserdata'
    $P1 = new 'Array'
    setattribute $P0, 'data', $P1
    $S0 = $P0
    like($S0, '^userdata: <[0..9A..Fa..f]>*', "check tostring")
    $P2 = $P0.'tostring'()
    $S0 = $P2
    like($S0, '^userdata: <[0..9A..Fa..f]>*')
    $S0 = typeof $P2
    is($S0, 'string')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaUserdata'
    $P1 = new 'Array'
    setattribute $P0, 'data', $P1
    $P2 = $P0.'tonumber'()
    $S0 = $P2
    is($S0, 'nil', "check tonumber")
    $S0 = typeof $P2
    is($S0, 'nil')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

