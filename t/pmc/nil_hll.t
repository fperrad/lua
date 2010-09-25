#! ../../parrot
# Copyright (C) 2009-2010, Parrot Foundation.
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

    plan(9)

    check_HLL()
    check_tostring()
    check_tonumber()
    check_logical_not()
.end

.sub 'check_HLL'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check HLL")
    isa_ok($P0, 'LuaNil')
.end

.sub 'check_tostring'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check tostring")
    $P1 = $P0.'tostring'()
    isa_ok($P1, 'LuaString')
    $S0 = $P1
    is($S0, 'nil')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check tonumber")
    $P1 = $P0.'tonumber'()
    isa_ok($P1, 'LuaNil')
.end

.sub 'check_logical_not'
    $P0 = new 'LuaNil'
    $P1 = not $P0
    isa_ok($P1, 'LuaBoolean', "check logical_not")
    $S0 = $P1
    is($S0, 'true')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

