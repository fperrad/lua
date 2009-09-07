#! ../../parrot
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 LuaThread

=head2 Synopsis

    % parrot t/pmc/thread.t

=head2 Description

Tests Lua C<thread> type
(implemented in F<languages/lua/src/pmc/luathread.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'
    load_bytecode 'Parrot/Coroutine.pbc'

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
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $I0 = isa $P0, 'scalar'
    nok($I0, "check inheritance")
    $I0 = isa $P0, 'LuaAny'
    ok($I0)
    $I0 = isa $P0, 'LuaThread'
    ok($I0)
.end

.sub 'f1'
    print "f1()\n"
    end
.end

.sub 'check_interface'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $I0 = does $P0, 'scalar'
    ok($I0, "check interface")
    $I0 = does $P0, 'no_interface'
    nok($I0)
.end

.sub 'check_name'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $S0 = typeof $P0
    is($S0, 'thread', "check name")
.end

.sub 'check_get_string'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $S0 = $P0
    like($S0, '^thread: <[0..9A..Fa..f]>*', "check get_string")
.end

.sub 'check_get_bool'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $I0 = istrue $P0
    is($I0, 1, "check get_bool")
.end

.sub 'check_logical_not'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $P1 = not $P0
    $I0 = isa $P1, 'LuaBoolean'
    ok($I0, "check logical_not")
    $S0 = $P1
    is($S0, 'false')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

