#! ../../parrot
# Copyright (C) 2005-2009, Parrot Foundation.
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

    plan(5)

    check_HLL()
    check_tostring()
    check_tonumber()
    check__add()
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
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $P1 = new 'LuaNumber'
    set $P1, 3.14
    push_eh _handler
    $P2 = add $P0, $P1
    ok(0)
    pop_eh
    end
  _handler:
    .local pmc ex
    .get_results (ex)
    $S0 = ex
    # attempt to perform arithmetic on a thread value
#    like($S0, '^attempt')
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

