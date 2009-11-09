#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .const 'Sub' prebuild = 'prebuild'
    register_step_before('build', prebuild)

    .const 'Sub' clean = 'clean'
    register_step_before('clean', clean)

    # build
    $P0 = new 'Hash'
    $P1 = new 'Hash'
    $P2 = split "\n", <<'SOURCES'
dynext/pmc/lua.pmc
dynext/pmc/luaany.pmc
dynext/pmc/luaboolean.pmc
dynext/pmc/luabytecode.pmc
dynext/pmc/luafunction.pmc
dynext/pmc/luanil.pmc
dynext/pmc/luanumber.pmc
dynext/pmc/luastring.pmc
dynext/pmc/luatable.pmc
dynext/pmc/luathread.pmc
dynext/pmc/luauserdata.pmc
SOURCES
    $S0 = pop $P2
    $P1['lua_group'] = $P2
    $P0['dynpmc'] = $P1

    $P3 = new 'Hash'
    $P3['lua/lua51_gen.pir'] = 'lua/lua51.pg'
    $P3['lua/lua51_testlex_gen.pir'] = 'lua/lua51_testlex.pg'
    $P0['pir_pge'] = $P3

    $P4 = new 'Hash'
    $P4['lua/PASTGrammar_gen.pir'] = 'lua/PASTGrammar.tg'
    $P4['lua/POSTGrammar_gen.pir'] = 'lua/POSTGrammar.tg'
    $P4['lua/dumplex_gen.pir'] = 'lua/dumplex.tg'
    $P0['pir_tge'] = $P4

    $P5 = new 'Hash'
    $P6 = split "\n", <<'SOURCES'
lua/lua51.pir
lua/grammar51.pir
lua/lua51_gen.pir
lua/PASTGrammar_gen.pir
lua/POSTGrammar_gen.pir
lua/lib/luaaux.pir
lua/lib/luabasic.pir
lua/lib/luacoroutine.pir
lua/lib/luapackage.pir
lua/lib/luaregex.pir
lua/lib/luastring.pir
lua/lib/luatable.pir
lua/lib/luamath.pir
lua/lib/luaio.pir
lua/lib/luafile.pir
lua/lib/luaos.pir
lua/lib/luadebug.pir
lua/lib/luabytecode.pir
lua/lib/luabytecode_gen.pir
SOURCES
    $S0 = pop $P6
    $P5['lua/lua.pbc'] = $P6
    $P5['lua.pbc'] = 'lua.pir'
    $P5['luap.pbc'] = 'luap.pir'
    $P5['lua/luad.pbc'] = 'luad.pir'
    $P0['pbc_pir'] = $P5

    $P7 = new 'Hash'
    $P7['parrot-lua'] = 'lua.pbc'
    $P7['parrot-luap'] = 'luap.pbc'
    $P0['exe_pbc'] = $P7

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0
    $P0['prove_files'] = 't/pmc/*.t'

    # install
    $P8 = split ' ', 'lua/lua.pbc lua/luad.pbc'
    $P0['inst_lang'] = $P8
    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'prebuild' :anon
    .param pmc kv :slurpy :named
    .local string cmd
    $P0 = split ' ', 'lua/lib/luabytecode.rules build/translator.pl'
    $I0 = newer('lua/lib/luabytecode_gen.pir', $P0)
    if $I0 goto L1
    cmd = 'perl build/translator.pl'
    cmd .= ' --output lua/lib/luabytecode_gen.pir'
    cmd .= ' lua/lib/luabytecode.rules'
    system(cmd)
  L1:
.end

.sub 'clean' :anon
    .param pmc kv :slurpy :named
    unlink('lua/lib/luabytecode_gen.pir')
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
