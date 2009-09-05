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
    $I0 = isa $P0, 'LuaString'
    is($I0, 1)
.end

.sub 'check_HLL_autoboxing'
    $P0 = fct()
    $S0 = $P0
    is($S0, "simple string", "check HLL autoboxing")
    $I0 = isa $P0, 'LuaString'
    is($I0, 1)
.end

.sub 'fct' :anon
    .return ("simple string")
.end

.sub 'check_HLL_const'
    .const 'LuaString' K = "simple string"
    $S0 = K
    is($S0, "simple string", "check HLL & .const")
    $I0 = isa K, 'LuaString'
    is($I0, 1)
.end

.sub 'check_empty_string'
    .const 'LuaString' K = ''
    $S0 = K
    is($S0, '', "check empty string")
    $I0 = isa K, 'LuaString'
    is($I0, 1)
.end

.sub 'check_box'
    $P0 = box "simple string"
    $S0 = $P0
    is($S0, "simple string", "check box")
    $I0 = isa $P0, 'LuaString'
    is($I0, 1)
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
    $S0 = $P1
    is($S0, 'value')
    $S0 = typeof $P1
    is($S0, 'string')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaString'
    set $P0, '3.14'
    $S0 = $P0
    is($S0, '3.14', "check tonumber")
    $P1 = $P0.'tonumber'()
    $S0 = $P1
    is($S0, '3.14')
    $S0 = typeof $P1
    is($S0, 'number')
.end

.sub 'check_tobase'
    $P0 = new 'LuaString'
    set $P0, '111'
    $S0 = $P0
    is($S0, '111', "check tobase")
    $P1 = $P0.'tobase'(2)
    $S0 = $P1
    is($S0, '7')
    $S0 = typeof $P1
    is($S0, 'number')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

