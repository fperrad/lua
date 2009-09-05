#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaFunction

=head2 Synopsis

    % parrot t/pmc/function.t

=head2 Description

Tests C<LuaFunction> PMC
(implemented in F<languages/lua/src/pmc/luafunction.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(14)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
    check_get_bool()
    check_logical_not()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaFunction'
    $I0 = isa $P0, 'scalar'
    is($I0, 0, "check inheritance")
    $I0 = isa $P0, 'Sub'
    is($I0, 1)
    $I0 = isa $P0, 'Closure'
    is($I0, 0)
    $I0 = isa $P0, 'LuaAny'
    is($I0, 1)
    $I0 = isa $P0, 'LuaFunction'
    is($I0, 1)
.end

.sub 'check_interface'
    $P0 = new 'LuaFunction'
    $I0 = does $P0, 'scalar'
    is($I0, 1, "check interface")
    $I0 = does $P0, 'sub'
    is($I0, 1)
    $I0 = does $P0, 'no_interface'
    is($I0, 0)
.end

.sub 'check_name'
    $P0 = new 'LuaFunction'
    $S0 = typeof $P0
    is($S0, 'function', "check name")
.end

.sub 'check_get_string'
    $P0 = new 'LuaFunction'
    $S0 = $P0
    like($S0, '^function: <[0..9A..Fa..f]>*', "check get_string")
.end

.sub 'check_get_bool'
    $P0 = new 'LuaFunction'
    $I0 = istrue $P0
    is($I0, 1)
    .const 'Sub' F1 = 'f1'
    $I0 = istrue F1
    is($I0, 1, "check get_bool")
.end

.sub f1
    print "f1()\n"
    end
.end

.sub 'check_logical_not'
    $P0 = new 'LuaFunction'
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

