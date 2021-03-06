#! ../../parrot
# Copyright (C) 2005-2010, Parrot Foundation.
# $Id$

=head1 LuaThread

=head2 Synopsis

    % parrot t/pmc/thread_hll.t

=head2 Description

Tests Lua C<thread> type
(implemented in F<languages/lua/src/pmc/luathread.pmc>).

=cut

.HLL 'lua'
.loadlib 'lua_group'

.sub 'main' :main
    load_bytecode 'Parrot/Coroutine.pbc'

    .include 'test_more.pir'

    plan(8)

    check_HLL()
    check_tostring()
    check_tonumber()
    check__add()
    check_logical_not()
.end

.sub 'check_HLL'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    isa_ok($P0, 'LuaThread', "check HLL")
.end

.sub 'f1'
    print "f1()\n"
    end
.end

.sub 'check_tostring'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $S0 = $P0
    like($S0, '^thread: <[0..9A..Fa..f]>*', "check tostring")
    $P1 = $P0.'tostring'()
    isa_ok($P1, 'LuaString')
    $S0 = $P1
    like($S0, '^thread: <[0..9A..Fa..f]>*')
.end

.sub 'check_tonumber'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $P1 = $P0.'tonumber'()
    isa_ok($P1, 'LuaNil', "check tonumber")
.end

.sub 'check__add'
    # attempt to perform arithmetic on a thread value
    throws_like(<<'CODE', '^attempt', "check __add")
  .sub ''
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $P1 = new 'LuaNumber'
    set $P1, 3.14
    $P2 = add $P0, $P1
  .end

  .sub 'f1'
    print "f1()\n"
    end
  .end
CODE
.end

.sub 'check_logical_not'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
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

