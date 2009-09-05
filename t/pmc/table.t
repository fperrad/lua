#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaTable

=head2 Synopsis

    % parrot t/pmc/table.t

=head2 Description

Tests C<table> type
(implemented in F<languages/lua/src/pmc/luatable.pmc>).

=cut

.sub 'main' :main
    loadlib $P0, 'lua_group'

    .include 'test_more.pir'

    plan(18)

    check_inheritance()
    check_interface()
    check_name()
    check_get_string()
    check_get_bool()
    check_logical_not()
    check_key_PMC()
    check_key_nil()
    check_deletion()
.end

.sub 'check_inheritance'
    $P0 = new 'LuaTable'
    $I0 = isa $P0, 'scalar'
    is($I0, 0, "check ingeritance")
    $I0 = isa $P0, 'LuaAny'
    is($I0, 1)
    $I0 = isa $P0, 'LuaTable'
    is($I0, 1)
.end

.sub 'check_interface'
    $P0 = new 'LuaTable'
    $I0 = does $P0, 'scalar'
    is($I0, 0, "check interface")
    $I0 = does $P0, 'no_interface'
    is($I0, 0)
.end

.sub 'check_name'
    $P0 = new 'LuaTable'
    $S0 = typeof $P0
    is($S0, 'table', "check name")
.end

.sub 'check_get_string'
    $P0 = new 'LuaTable'
    $S0 = $P0
    like($S0, '^table: <[0..9A..Fa..f]>*', "check get_string")
.end

.sub 'check_get_bool'
    $P0 = new 'LuaTable'
    $I0 = istrue $P0
    is($I0, 1, "check get_bool")
.end

.sub 'check_logical_not'
    $P0 = new 'LuaTable'
    $P1 = not $P0
    $S0 = $P1
    is($S0, 'false', "check logical_not")
    $S0 = typeof $P1
    is($S0, 'boolean')
.end

.sub 'check_key_PMC'
    $P0 = new 'LuaTable'
    .local pmc val1
    val1 = new 'LuaString'
    val1 = "value1"
    .local pmc val2
    val2 = new 'LuaString'
    val2 = "value2"
    $P0[val1] = val1
    $P0[val2] = val2
    $P1 = $P0[val1]
    $S0 = $P1
    is($S0, "value1", "check key PMC")
    $P1 = $P0[val2]
    $S0 = $P1
    is($S0, "value2")
    $P1 = $P0[$P0]
    $S0 = $P1
    is($S0, 'nil')
 .end

.sub 'check_key_nil'
    $P0 = new 'LuaTable'
    .local pmc val1
    val1 = new 'LuaString'
    val1 = "value1"
    .local pmc nil
    nil = new 'LuaNil'
    push_eh _handler
    $P0[nil] = val1
    ok(0, "check key nil")
    pop_eh
    end
  _handler:
    .local pmc ex
    .get_results (ex)
    $S0 = ex
    # table index is nil
    like($S0, '^table', "check key nil")
.end

.sub 'check_deletion' # by assignment of nil
    $P0 = new 'LuaTable'
    .local pmc val1
    val1 = new 'LuaString'
    val1 = "value1"
    .local pmc val2
    val2 = new 'LuaString'
    val2 = "value2"
    $I0 = elements $P0
    is($I0, 0, "check deletion")
    $P0[val1] = val1
    $I0 = elements $P0
    is($I0, 1)
    $P0[val2] = val2
    $I0 = elements $P0
    is($I0, 2)
    .local pmc nil
    nil = new 'LuaNil'
    $P0[val1] = nil
    $I0 = elements $P0
    is($I0, 1)
.end

# Local Variables:
#   mode: pir
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

