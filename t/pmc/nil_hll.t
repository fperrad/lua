#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaNil

=head2 Synopsis

    % parrot t/pmc/nil_hll.t

=head2 Description

Tests C<LuaNil> PMC
(implemented in F<languages/lua/src/pmc/luanil.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(10)

    check_HLL()
    check_HLL_const()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check HLL")
    $I0 = isa $P0, 'LuaNil'
    ok($I0)
.end

.sub 'check_HLL_const'
    .const 'LuaNil' K = 'dummy'
    $S0 = K
    is($S0, 'nil', "check HLL & .const")
    $I0 = isa K, 'LuaNil'
    ok($I0)
.end

.sub 'check_tostring'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check tostring")
    $P1 = $P0.'tostring'()
    $S0 = $P1
    is($S0, 'nil')
    $S0 = typeof $P1
    is($S0, 'string')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check tonumber")
    $P1 = $P0.'tonumber'()
    $S0 = $P1
    is($S0, 'nil')
    $S0 = typeof $P1
    is($S0, 'nil')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

