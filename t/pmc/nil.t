#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaNil

=head2 Synopsis

    % parrot t/pmc/nil.t

=head2 Description

Tests C<LuaNil> PMC
(implemented in F<languages/lua/src/pmc/luanil.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(9)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
    check_get_bool()
    check_logical_not()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaNil'
    $I0 = isa $P0, 'LuaAny'
    is($I0, 1, "check inheritance")
    $I0 = isa $P0, 'LuaNil'
    is($I0, 1)
.end

.sub 'check_interface'
    $P0 = new 'LuaNil'
    $I0 = does $P0, 'scalar'
    is($I0, 1, "check interface")
    $I0 = does $P0, 'no_interface'
    is($I0, 0)
.end

.sub 'check_name'
    $P0 = new 'LuaNil'
    $S0 = typeof $P0
    is($S0, 'nil', "check name")
.end

.sub 'check_get_string'
    $P0 = new 'LuaNil'
    $S0 = $P0
    is($S0, 'nil', "check get_string")
.end

.sub 'check_get_bool'
    $P0 = new 'LuaNil'
    $I0 = isfalse $P0
    is($I0, 1, "check get_bool")
.end

.sub 'check_logical_not'
    $P0 = new 'LuaNil'
    $P1 = not $P0
    $S0 = $P1
    is($S0, 'true', "check logical_not")
    $S0 = typeof $P1
    is($S0, 'boolean')
.end

# Local Variables:
#   mode: pir
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

