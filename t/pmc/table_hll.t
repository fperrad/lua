#! ../../parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaTable

=head2 Synopsis

    % parrot t/pmc/table_hll.t

=head2 Description

Tests C<table> type
(implemented in F<languages/lua/src/pmc/luatable.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    .include 'test_more.pir'

    plan(12)

    check_HLL()
    check_len()
    check_next()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    $P0 = new 'LuaTable'
    $I0 = isa $P0, 'LuaTable'
    is($I0, 1)
.end

.sub 'check_len'
    $P0 = new 'LuaTable'
    .local pmc key1
    key1 = new 'LuaNumber'
    set key1, 1
    .local pmc val1
    val1 = new 'LuaString'
    set val1, "value1"
    $P0[key1] = val1
    inc key1
    .local pmc val2
    val2 = new 'LuaString'
    set val2, "value2"
    $P0[key1] = val2
    inc key1
    .local pmc val3
    val3 = new 'LuaString'
    set val3, "value3"
    $P0[key1] = val3
    inc key1
    .local pmc val4
    val4 = new 'LuaString'
    set val4, "value4"
    $P0[key1] = val4
    .local pmc len
    len = $P0.'len'()
    $I0 = len
    is($I0, 4)
    val3 = new 'LuaNil'
    dec key1
    $P0[key1] = val3
    len = $P0.'len'()
    $I0 = len
    is($I0, 2)
.end

.sub 'check_next'
    .local pmc pmc1
    pmc1 = new 'LuaTable'
    .local pmc key1
    key1 = new 'LuaNumber'
    set key1, 1
    .local pmc val1
    val1 = new 'LuaString'
    set val1, "value1"
    pmc1[key1] = val1
    inc key1
    .local pmc val2
    val2 = new 'LuaString'
    set val2, "value2"
    pmc1[key1] = val2
    inc key1
    .local pmc val3
    val3 = new 'LuaString'
    set val3, "value3"
    pmc1[key1] = val3
    .local pmc nil
    nil = new 'LuaNil'
    .local pmc pmc2, key
    $P0 = pmc1.'next'(nil)
    key = $P0[0]
    pmc2 = $P0[1]
    $S0 = pmc2
    is($S0, "value1")
    $P0 = pmc1.'next'(key)
    key = $P0[0]
    pmc2 = $P0[1]
    $S0 = pmc2
    is($S0, "value2")
    $P0 = pmc1.'next'(key)
    key = $P0[0]
    pmc2 = $P0[1]
    $S0 = pmc2
    is($S0, "value3")
    $P0 = pmc1.'next'(key)
    $S0 = $P0
    is($S0, 'nil')
.end

.sub 'check_tostring'
    $P0 = new 'LuaTable'
    $S0 = $P0
    like($S0, '^table: <[0..9A..Fa..f]>*')
    $P1 = $P0.'tostring'()
    $S0 = $P1
    like($S0, '^table: <[0..9A..Fa..f]>*')
    $S0 = typeof $P1
    is($S0, 'string')
.end

.sub 'check_tonumber'
    $P0 = new 'LuaTable'
    $P1 = $P0.'tonumber'()
    $S0 = $P1
    is($S0, 'nil')
    $S0 = typeof $P1
    is($S0, 'nil')
.end

# Local Variables:
#   mode: pir
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

