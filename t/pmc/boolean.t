#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaBoolean

=head1 Synopsis

    % parrot t/pmc/boolean.t

=head2 Description

Tests C<LuaBoolean> PMC
(implemented in F<languages/lua/src/pmc/luaboolean.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(9)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaBoolean'
    $I0 = isa $P0, 'LuaAny'
    ok($I0, "check inheritance")
    $I0 = isa $P0, 'LuaBoolean'
    ok($I0)
.end

.sub 'check_interface'
    $P0 = new 'LuaBoolean'
    $I0 = does $P0, 'scalar'
    ok($I0, "check interface")
    $I0 = does $P0, 'boolean'
    ok($I0)
    $I0 = does $P0, 'integer'
    ok($I0)
    $I0 = does $P0, 'no_interface'
    nok($I0)
.end

.sub 'check_name'
    $P0 = new 'LuaBoolean'
    $S0 = typeof $P0
    is($S0, 'boolean', "check name")
.end

.sub 'check_get_string'
    $P0 = new 'LuaBoolean'
    set $P0, 0
    $S0 = $P0
    is($S0, 'false', "check get_string")
    set $P0, 1
    $S0 = $P0
    is($S0, 'true')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

