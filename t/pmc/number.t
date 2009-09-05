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
    is($I0, 1, "check inheritance")
    $I0 = isa $P0, 'LuaNumber'
    is($I0, 1)
.end

.sub 'check_interface'
    $P0 = new 'LuaNumber'
    $I0 = does $P0, 'scalar'
    is($I0, 1, "check interface")
    $I0 = does $P0, 'float'
    is($I0, 1)
    $I0 = does $P0, 'no_interface'
    is($I0, 0)
.end

.sub 'check_name'
    $P0 = new 'LuaNumber'
    $S0 = typeof $P0
    is($S0, 'number', "check name")
.end

.sub 'check_set_integer_native'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $S0 = typeof $P0
    is($S0, 'number', "check set_integer_native")
    $S0 = $P0
    is($S0, '3.14')
    set $P0, 2
    $S0 = typeof $P0
    is($S0, 'number')
    $S0 = $P0
    is($S0, '2')
.end

.sub 'check_logical_not'
    $P0 = new 'LuaNumber'
    set $P0, 3.14
    $P1 = not $P0
    $S0 = $P1
    is($S0, 'false', "check logical_not")
    $S0 = typeof $P1
    is($S0, 'boolean')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

