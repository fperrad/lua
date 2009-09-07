#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaNumber

=head2 Synopsis

    % parrot t/pmc/number_hll.t

=head2 Description

Tests C<LuaNumber> PMC
(implemented in F<languages/lua/src/pmc/luanumber.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(16)

    check_HLL()
    check_HLL_autoboxing()
    check_HLL_const()
    check_box_float()
    check_box_integer()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $N0 = $P0
    is($N0, 3.14, "check HLL")
    isa_ok($P0, 'LuaNumber')
.end

.sub 'check_HLL_autoboxing'
    $P0 = fct()
    $N0 = $P0
    is($N0, 3.14, "check HLL autoboxing")
    isa_ok($P0, 'LuaNumber')
.end

.sub 'fct' :anon
    .return (3.14)
.end

.sub 'check_HLL_const'
    .const 'LuaNumber' K = '3.14'
    $N0 = K
    is($N0, 3.14, "check HLL & .const")
    isa_ok(K, 'LuaNumber')
.end

.sub 'check_box_float'
    $P0 = box 3.14
    $N0 = $P0
    is($N0, 3.14, "check box float")
    isa_ok($P0, 'LuaNumber')
.end

.sub 'check_box_integer'
    $P0 = box -2
    $N0 = $P0
    is($N0, -2, "check box integer")
    isa_ok($P0, 'LuaNumber')
.end

.sub 'check_tostring'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $N0 = $P0
    is($N0, 3.14, "check tostring")
    $P1 = $P0.'tostring'()
    isa_ok($P1, 'LuaString')
    $S0 = $P1
    is($S0, '3.14')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $N0 = $P0
    is($N0, 3.14, "check tonumber")
    $P1 = $P0.'tonumber'()
    isa_ok($P1, 'LuaNumber')
    $N0 = $P1
    is($N0, 3.14)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

