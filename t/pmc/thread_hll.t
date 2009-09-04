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

    plan(6)

    check_HLL()
    check_tostring()
    check_tonumber()
.end

.sub 'check_HLL'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $I0 = isa $P0, 'LuaThread'
    is($I0, 1)
.end

.sub 'f1'
    print "f1()\n"
    end
.end

.sub 'check_tostring'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $S0 = $P0
    like($S0, '^thread: <[0..9A..Fa..f]>*')
    $P1 = $P0.'tostring'()
    $S0 = $P1
    like($S0, '^thread: <[0..9A..Fa..f]>*')
    $S0 = typeof $P1
    is($S0, 'string')
.end

.sub 'check_tonumber'
    .const 'Sub' F1 = 'f1'
    $P0 = new 'LuaThread', F1
    $P1 = $P0.'tonumber'()
    $S0 = $P1
    is($S0, 'nil')
    $S0 = typeof $P1
    is($S0, 'nil')
.end

#~ pir_error_output_like( << 'CODE', << 'OUTPUT', 'check __add' );
#~ .HLL 'lua'
#~ .loadlib 'lua_group'
#~ .sub '__start' :main
    #~ load_bytecode 'Parrot/Coroutine.pbc'
    #~ _main()
#~ .end
#~ .sub '_main'
    #~ .const 'LuaNumber' cst1 = '3.14'
    #~ .const 'Sub' F1 = 'f1'
    #~ .local pmc pmc1
    #~ pmc1 = new 'LuaThread', F1
    #~ $P0 = add pmc1, cst1
    #~ end
#~ .end
#~ .sub 'f1'
    #~ print "f1()\n"
    #~ end
#~ .end
#~ CODE
#~ /^attempt to perform arithmetic on a thread value/
#~ OUTPUT

# Local Variables:
#   mode: pir
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

