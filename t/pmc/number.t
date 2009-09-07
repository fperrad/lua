#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaNumber

=head2 Synopsis

    % parrot t/pmc/number.t

=head2 Description

Tests C<LuaNumber> PMC
(implemented in F<languages/lua/src/pmc/luanumber.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(12)

    check_inheritance()
    check_interface()
    check_name()
    check_set_integer_native()
    check_logical_not()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaNumber'
    $I0 = isa $P0, 'LuaAny'
    ok($I0, "check inheritance")
    $I0 = isa $P0, 'LuaNumber'
    ok($I0)
.end

.sub 'check_interface'
    $P0 = new 'LuaNumber'
    $I0 = does $P0, 'scalar'
    ok($I0, "check interface")
    $I0 = does $P0, 'float'
    ok($I0)
    $I0 = does $P0, 'no_interface'
    nok($I0)
.end

.sub 'check_name'
    $P0 = new 'LuaNumber'
    $S0 = typeof $P0
    is($S0, 'number', "check name")
.end

.sub 'check_set_integer_native'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    isa_ok($P0, 'LuaNumber', "check set_integer_native")
    $N0 = $P0
    is($N0, 3.14)
    set $P0, 2
    isa_ok($P0, 'LuaNumber')
    $N0 = $P0
    is($N0, 2)
.end

.sub 'check_logical_not'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $P1 = not $P0
    isa_ok($P1, 'LuaBoolean', "check logical_not")
    $S0 = $P1
    is($S0, 'false')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

