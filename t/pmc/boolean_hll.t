#! ../../parrot
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 LuaBoolean

=head1 Synopsis

    % parrot t/pmc/boolean_hll.t

=head2 Description

Tests C<LuaBoolean> PMC
(implemented in F<languages/lua/src/pmc/luaboolean.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(9)

    check_HLL()
    check_HLL_const()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    $P0 = new 'LuaBoolean'
    set $P0, 1
    $S0 = $P0
    is($S0, 'true', "check HLL")
    isa_ok($P0, 'LuaBoolean')
.end

.sub 'check_HLL_const'
    .const 'LuaBoolean' K = '1'
    $S0 = K
    is($S0, 'true', "check HLL & .const")
    isa_ok(K, 'LuaBoolean')
.end

.sub 'check_tostring'
    $P0 = new 'LuaBoolean'
    set $P0, 1
    $S0 = $P0
    is($S0, 'true', "check tostring")
    $P1 = $P0.'tostring'()
    isa_ok($P1, 'LuaString')
    $S0 = $P1
    is($S0, 'true')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaBoolean'
    set $P0, 1
    $S0 = $P0
    is($S0, 'true', "check tonumber")
    $P1 = $P0.'tonumber'()
    isa_ok($P1, 'LuaNil')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

