#!/usr/local/bin/parrot
# Copyright (C) 2007-2009, Parrot Foundation.
# $Id$

=head1 Lua Stand-alone & environment variables

=head2 Synopsis

    % parrot t/env.t

=head2 Description

=cut

.sub 'main' :main
    $P0 = loadlib 'os'
    .include 'test_more.pir'

    $P0 = new 'FileHandle'
    $P0.'open'('hello.lua', 'w')
    $P0.'puts'("print [[Hello World]]\n")
    $P0.'close'()

    plan(5)

    test_LUA_INIT_string()
    test_LUA_INIT_bad_string()
    test_LUA_INIT_file()
    test_LUA_INIT_bad_file()
    test_LUA_INIT_no_file()

    $P0 = new 'OS'
    $P0.'rm'('hello.lua')
.end

.sub 'lua' :anon
    .param string filename
    .param string params  :optional
    .param int has_params :opt_flag
    .local string cmd
    cmd = "parrot lua.pbc " . filename
    unless has_params goto L1
    cmd .= " "
    cmd .= params
  L1:
    $P0 = new 'FileHandle'
    $P0.'open'(cmd, 'rp')
    $S0 = $P0.'readall'()
    $P0.'close'()
    .return ($S0)
.end

.sub 'test_LUA_INIT_string'
    $P0 = new 'Env'
    $P0['LUA_INIT'] = "print [[init]]"
    $S0 = lua('hello.lua')
    is($S0, "init\nHello World\n", "LUA_INIT string")
    delete $P0['LUA_INIT']
.end

.sub 'test_LUA_INIT_bad_string'
    $P0 = new 'Env'
    $P0['LUA_INIT'] = "?syntax error?"
    $S0 = lua('hello.lua')
    like($S0, ":s lua", "LUA_INIT bad string")
    delete $P0['LUA_INIT']
.end

.sub 'test_LUA_INIT_file'
    $P0 = new 'Env'
    $P0['LUA_INIT'] = "@boot.lua"
    $P1 = new 'FileHandle'
    $P1.'open'('boot.lua', 'w')
    $P1.'puts'("print [[boot from boot.lua by LUA_INIT]]\n")
    $P1.'close'()
    $S0 = lua('hello.lua')
    is($S0, "boot from boot.lua by LUA_INIT\nHello World\n", "LUA_INIT file")
    delete $P0['LUA_INIT']
    $P0 = new 'OS'
    $P0.'rm'('boot.lua')
.end

.sub 'test_LUA_INIT_bad_file'
    $P0 = new 'Env'
    $P0['LUA_INIT'] = "@boot.lua"
    $P1 = new 'FileHandle'
    $P1.'open'('boot.lua', 'w')
    $P1.'puts'("?syntax error?\n")
    $P1.'close'()
    $S0 = lua('hello.lua')
    like($S0, ":s lua", "LUA_INIT bad file")
    delete $P0['LUA_INIT']
    $P0 = new 'OS'
    $P0.'rm'('boot.lua')
.end

.sub 'test_LUA_INIT_no_file'
    $P0 = new 'Env'
    $P0['LUA_INIT'] = "@no_file.lua"
    $S0 = lua('hello.lua')
    like($S0, ":s cannot open no_file", "LUA_INIT no file")
    delete $P0['LUA_INIT']
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
