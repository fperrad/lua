#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaUserdata

=head2 Synopsis

    % parrot t/pmc/userdata.t

=head2 Description

Tests C<userdata> type
(implemented in F<languages/lua/src/pmc/luauserdata.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(10)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
    check_get_bool()
    check_logical_not()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaUserdata'
    $I0 = isa $P0, 'scalar'
    nok($I0, "check inheritance")
    $I0 = isa $P0, 'LuaAny'
    ok($I0)
    $I0 = isa $P0, 'LuaUserdata'
    ok($I0)
.end

.sub 'check_interface'
    $P0 = new 'LuaUserdata'
    $I0 = does $P0, 'scalar'
    ok($I0, "check interface")
    $I0 = does $P0, 'no_interface'
    nok($I0)
.end

.sub 'check_name'
    $P0 = new 'LuaUserdata'
    $S0 = typeof $P0
    is($S0, 'userdata', "check name")
.end

.sub 'check_get_string'
    $P0 = new 'LuaUserdata'
    $S0 = $P0
    like($S0, '^userdata: <[0..9A..Fa..f]>*', "check get_string")
.end

.sub 'check_get_bool'
    $P0 = new 'LuaUserdata'
    $P1 = new 'Array'
    setattribute $P0, 'data', $P1
    $I0 = istrue $P0
    is($I0, 1, "check get_bool")
.end

.sub 'check_logical_not'
    $P0 = new 'LuaUserdata'
    $P1 = new 'Array'
    setattribute $P0, 'data', $P1
    $P2 = not $P0
    $I0 = isa $P2, 'LuaBoolean'
    ok($I0, "check logical_not")
    $S0 = $P2
    is($S0, 'false')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

