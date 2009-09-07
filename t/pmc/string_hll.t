#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaString

=head2 Synopsis

    % parrot t/pmc/string_hll.t

=head2 Description

Tests C<LuaString> PMC
(implemented in F<languages/lua/src/pmc/luastring.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(20)

    check_HLL()
    check_HLL_autoboxing()
    check_HLL_const()
    check_empty_string()
    check_box()
    check_is_equal()
    check_tostring()
    check_tonumber()
    check_tobase()
.end

.sub 'check_HLL'
    $P0 = new 'LuaString'
    set $P0, "simple string"
    $S0 = $P0
    is($S0, "simple string", "check HLL")
    isa_ok($P0, 'LuaString')
.end

.sub 'check_HLL_autoboxing'
    $P0 = fct()
    $S0 = $P0
    is($S0, "simple string", "check HLL autoboxing")
    isa_ok($P0, 'LuaString')
.end

.sub 'fct' :anon
    .return ("simple string")
.end

.sub 'check_HLL_const'
    .const 'LuaString' K = "simple string"
    $S0 = K
    is($S0, "simple string", "check HLL & .const")
    isa_ok(K, 'LuaString')
.end

.sub 'check_empty_string'
    .const 'LuaString' K = ''
    $S0 = K
    is($S0, '', "check empty string")
    isa_ok(K, 'LuaString')
.end

.sub 'check_box'
    $P0 = box "simple string"
    $S0 = $P0
    is($S0, "simple string", "check box")
    isa_ok($P0, 'LuaString')
.end

.sub 'check_is_equal'
    $P1 = new 'LuaString'
    set $P1, 'str'
    $P2 = new 'LuaString'
    set $P2, 'str'
    $I0 = iseq $P1, $P2
    is($I0, 1, "check is_equal (RT #60292)")
.end

.sub 'check_tostring'
    $P0 = new 'LuaString'
    set $P0, 'value'
    $S0 = $P0
    is($S0, 'value', "check tostring")
    $P1 = $P0.'tostring'()
    isa_ok($P1, 'LuaString')
    $S0 = $P1
    is($S0, 'value')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaString'
    set $P0, '3.14'
    $S0 = $P0
    is($S0, '3.14', "check tonumber")
    $P1 = $P0.'tonumber'()
    isa_ok($P1, 'LuaNumber')
    $N0 = $P1
    is($N0, 3.14)
.end

.sub 'check_tobase'
    $P0 = new 'LuaString'
    set $P0, '111'
    $S0 = $P0
    is($S0, '111', "check tobase")
    $P1 = $P0.'tobase'(2)
    isa_ok($P1, 'LuaNumber')
    $I0 = $P1
    is($I0, 7)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

