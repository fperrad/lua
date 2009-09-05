#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaFunction

=head2 Synopsis

    % parrot t/pmc/function_hll.t

=head2 Description

Tests C<LuaFunction> PMC
(implemented in F<languages/lua/src/pmc/luafunction.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(15)

    check_HLL()
    check_HLL_autoboxing()
    check_tostring()
    check_tonumber()
    check_init_pmc()
    load_from_pbc_1()
    load_from_pbc_2()
.end

.sub 'check_HLL'
#    .const 'LuaFunction' F1 = 'f1'
    .const 'Sub' F1 = 'f1'
    $I0 = isa F1, 'LuaFunction'
    is($I0, 1, "check HLL")
    $S0 = F1()
    is($S0, "f1()")
    .const 'Sub' F2 = 'f2'
    $I0 = isa F2, 'LuaFunction'
    is($I0, 1)
    $S0 = F2()
    is($S0, "f2()")
.end

.sub f1
    .return ("f1()")
.end

.sub f2 :outer(check_HLL)
    .return ("f2()")
.end

.sub 'check_HLL_autoboxing'
    $P0 = fct1()
    $I0 = isa $P0, 'LuaFunction'
    is($I0, 1, "check HLL autoboxing")
    $P0 = fct2()
    $I0 = isa $P0, 'LuaFunction'
    is($I0, 1)
.end

.sub 'fct1'
    .const 'Sub' T = 'fct1'
    .return (T)
.end

.sub 'fct2' :outer(check_HLL_autoboxing)
    .const 'Sub' T = 'fct2'
    .return (T)
.end

.sub 'check_tostring'
    $P0 = new 'LuaFunction'
    $S0 = $P0
    like($S0, '^function: <[0..9A..Fa..f]>*', "check tostring")
    $P1 = $P0.'tostring'()
    $S0 = $P1
    like($S0, '^function: <[0..9A..Fa..f]>*')
    $S0 = typeof $P1
    is($S0, 'string')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaFunction'
    $P1 = $P0.'tonumber'()
    $S0 = $P1
    is($S0, 'nil', "check tonumber")
    $S0 = typeof $P1
    is($S0, 'nil')
.end

.sub 'check_init_pmc'
    .const 'Sub'F1 = 'f1'
    $P0 = new 'LuaFunction', F1
    $I0 = isa $P0, 'LuaFunction'
    is($I0, 1, "check init_pmc")
    $S0 = $P0()
    is($S0, "f1()")
.end

.sub 'load_from_pbc_1'
    load_bytecode 'src/lib/luaaux.pbc'
    load_bytecode 'src/lib/luabasic.pbc'
    $P0 = get_hll_global ['basic'], 'luaopen_basic'
    $P0()
    $P1 = get_hll_global '_G'
    .const 'LuaString' k_print = 'print'
    $P2 = $P1[k_print]
    $I0 = isa $P2, 'LuaFunction'
    is($I0, 1, "load from pbc")
#    $P2($P2)
.end

.sub 'load_from_pbc_2'
    load_bytecode 'languages/lua/lua.pbc'
    lua_openlibs()
    $P1 = get_hll_global '_G'
    .const 'LuaString' k_print = 'print'
    $P2 = $P1[k_print]
    $I0 = isa $P2, 'LuaFunction'
    is($I0, 1, "load from pbc")
#    $P2($P2)
.end

# Local Variables:
#   mode: pir
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

