#! ../../parrot
# Copyright (C) 2009-2010, Parrot Foundation.
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

    plan(11)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
    check_get_bool()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaFunction'
    $I0 = isa $P0, 'scalar'
    nok($I0, "check inheritance")
    $I0 = isa $P0, 'Sub'
    ok($I0)
    $I0 = isa $P0, 'Closure'
    nok($I0)
    $I0 = isa $P0, 'LuaAny'
    ok($I0)
    $I0 = isa $P0, 'LuaFunction'
    ok($I0)
.end

.sub 'check_interface'
    $P0 = new 'LuaFunction'
    $I0 = does $P0, 'invokable'
    ok($I0, "check interface")
    $I0 = does $P0, 'no_interface'
    nok($I0)
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
    is($I0, 1, "check get_bool")
    .const 'Sub' F1 = 'f1'
    $I0 = istrue F1
    is($I0, 1)
.end

.sub f1
    print "f1()\n"
    end
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

