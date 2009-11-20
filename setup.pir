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

    .const 'Sub' update = 'update'
    register_step_after('update', update)

    .const 'Sub' prebuild = 'prebuild'
    register_step_before('build', prebuild)

    .const 'Sub' liblua_build = 'liblua_build'
    register_step_after('build', liblua_build)

    .const 'Sub' clean = 'clean'
    register_step_before('clean', clean)

    .const 'Sub' liblua_clean = 'liblua_clean'
    register_step_after('clean', liblua_clean)

    .const 'Sub' testclean = 'testclean'
    register_step_after('test', testclean)

    .const 'Sub' pmctest = 'pmctest'
    register_step('pmctest', pmctest)

    .const 'Sub' sanity = 'sanity'
    register_step('sanity', sanity)

    .const 'Sub' spectest = 'spectest'
    register_step('spectest', spectest)

    .const 'Sub' smolder = 'smolder'
    register_step('smolder', smolder)

    $P0 = new 'Hash'
    # build
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

    $P9 = new 'Hash'
    $P9['Test/More.pbc'] = 'Test/More.pir'
    $P0['liblua__pbc_pir'] = $P9
    $P10 = new 'Hash'
    $P10['Test/More.pir'] = 'Test/More.lua'
    $P0['liblua__pir_lua'] = $P10

    $P7 = new 'Hash'
    $P7['parrot-lua'] = 'lua.pbc'
    $P7['parrot-luap'] = 'luap.pbc'
    $P0['installable_pbc'] = $P7

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0
    $P0['prove_files'] = 't/pmc/*.t t/*.t'

    # install
    $P8 = split ' ', 'lua/lua.pbc lua/luad.pbc'
    $P0['inst_lang'] = $P8

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'update' :anon
    .param pmc kv :slurpy :named
    system('git submodule update')
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

    $I0 = file_exists('t/lua-TestMore/src/Test/More.lua')
    if $I0 goto L2
    system('git submodule init t/lua-TestMore')
    system('git submodule update')
  L2:

    $I0 = newer('Test/More.lua', 't/lua-TestMore/src/Test/More.lua')
    if $I0 goto L3
    install('t/lua-TestMore/src/Test/More.lua', 'Test/More.lua')
  L3:
.end

.sub 'clean' :anon
    .param pmc kv :slurpy :named
    unlink('lua/lib/luabytecode_gen.pir')
    unlink('Test/More.lua')
.end

.sub 'liblua_build' :anon
    .param pmc kv :slurpy :named
    $P0 = kv['liblua__pir_lua']
    build_pir_lua($P0)
    $P0 = kv['liblua__pbc_pir']
    build_pbc_pir($P0)
.end

.sub 'build_pir_lua' :anon
    .param pmc hash
    $P0 = iter hash
  L1:
    unless $P0 goto L2
    .local string pir, lua
    pir = shift $P0
    lua = hash[pir]
    $I0 = newer(pir, lua)
    if $I0 goto L1
    .local string cmd
    cmd = get_parrot()
    cmd .= " luap.pir --target=pir "
    cmd .= lua
    cmd .= " > "
    cmd .= pir
    system(cmd)
    goto L1
  L2:
.end

.sub 'liblua_clean' :anon
    .param pmc kv :slurpy :named
    $P0 = kv['liblua__pbc_pir']
    clean_key($P0)
    $P0 = kv['liblua__pir_lua']
    clean_key($P0)
.end

.sub 'testclean' :anon
    .param pmc kv :slurpy :named
    system("perl -MExtUtils::Command -e rm_f t/*.lua t/*.parrot_out t/*.luac")
.end

.sub 'pmctest' :anon
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    .local string cmd
    cmd = "prove --exec="
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " t/pmc/*.t"
    system(cmd)
.end

.sub 'sanity' :anon
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    .local string cmd
    cmd = "prove --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " lua.pbc\" t/lua-TestMore/test_lua51/0*.t"
    system(cmd)
.end

.sub 'spectest' :anon
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    setenv('LUA_INIT', "platform = { osname=[[MSWin32]], intsize=4, longsize=4 }")

    .local string cmd
    cmd = "prove --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " lua.pbc\" t/lua-TestMore/test_lua51/*.t"
    system(cmd)
.end

.sub 'smolder' :anon
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    setenv('LUA_INIT', "platform = { osname=[[MSWin32]], intsize=4, longsize=4 }")

    .local string cmd
    cmd = "prove --archive=test_lua51.tar.gz --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " lua.pbc\" t/lua-TestMore/test_lua51/*.t"
    system(cmd)

    .local pmc config
    config = get_config()
    cmd = "curl -F architecture="
    $S0 = config['cpuarch']
    cmd .= $S0
    cmd .= " -F platform="
    $S0 = config['osname']
    cmd .= $S0
    cmd .= " -F revision="
    $S0 = config['revision']
    cmd .= $S0
    cmd .= " -F tags=\""
    $S0 = config['osname']
    cmd .= $S0
    cmd .= ", "
    $S0 = config['archname']
    cmd .= $S0
    cmd .= ", parrot-lua, Lua 5.1 (on Parrot)\""
    cmd .= " -F comments=parrot-lua"
    cmd .= " -F report_file=@t/lua-TestMore/test_lua51/test_lua51.tar.gz"
    cmd .= "  http://smolder.plusthree.com/app/public_projects/process_add_report/12"
    system(cmd)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
