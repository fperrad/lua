#! ../../parrot
# Copyright (C) 2009-2010, Parrot Foundation.
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

    plan(7)

    check_HLL()
    check_tostring()
    check_tonumber()
    check_logical_not()
.end

.sub 'check_HLL'
    $P0 = new 'LuaUserdata'
    $P1 = new 'FileHandle'
    setattribute $P0, 'data', $P1
    isa_ok($P0, 'LuaUserdata', "check HLL")
.end

.sub 'check_tostring'
    $P0 = new 'LuaUserdata'
    $P1 = new 'FileHandle'
    setattribute $P0, 'data', $P1
    $S0 = $P0
    like($S0, '^userdata: <[0..9A..Fa..f]>*', "check tostring")
    $P2 = $P0.'tostring'()
    isa_ok($P2, 'LuaString')
    $S0 = $P2
    like($S0, '^userdata: <[0..9A..Fa..f]>*')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaUserdata'
    $P1 = new 'FileHandle'
    setattribute $P0, 'data', $P1
    $P2 = $P0.'tonumber'()
    isa_ok($P2, 'LuaNil', "check tonumber")
.end

.sub 'check_logical_not'
    $P0 = new 'LuaUserdata'
    $P1 = new 'FileHandle'
    setattribute $P0, 'data', $P1
    $P2 = not $P0
    isa_ok($P2, 'LuaBoolean', "check logical_not")
    $S0 = $P2
    is($S0, 'false')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

