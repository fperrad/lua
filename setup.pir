#!/usr/bin/env parrot
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

    .const 'Sub' pmctest = 'pmctest'
    register_step('pmctest', pmctest)

    .const 'Sub' set_LUA_INIT = 'set_LUA_INIT'
    register_step('set_LUA_INIT', set_LUA_INIT)
    register_step_before('test', set_LUA_INIT)
    register_step_before('smoke', set_LUA_INIT)

    .const 'Sub' sanity = 'sanity'
    register_step('sanity', sanity)

    .const 'Sub' spectest = 'spectest'
    register_step('spectest', spectest)

    $P0 = new 'Hash'
    $P0['name'] = 'Lua'
    $P0['abstract'] = 'Lua on Parrot'
    $P0['authority'] = 'http://github.com/fperrad'
    $P0['description'] = 'Lua 5.1 on Parrot'
    $P5 = split ',', 'lua'
    $P0['keywords'] = $P5
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/fperrad/lua.git'
    $P0['browser_uri'] = 'http://github.com/fperrad/lua'
    $P0['project_uri'] = 'http://github.com/fperrad/lua'

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

    $P7 = new 'Hash'
    $P7['parrot-lua'] = 'lua.pbc'
    $P7['parrot-luap'] = 'luap.pbc'
    $P0['installable_pbc'] = $P7

    # post build
    $P9 = new 'Hash'
    $P9['lua/library/Test/More.pbc'] = 'lua/library/Test/More.pir'
    $P0['liblua__pbc_pir'] = $P9
    $P10 = new 'Hash'
    $P10['lua/library/Test/More.pir'] = 'lua/library/Test/More.lua'
    $P0['liblua__pir_lua'] = $P10

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0
    $P0['prove_files'] = 't/pmc/*.t t/*.t'

    # smoke
    $P0['prove_archive'] = 'test_lua51.tar.gz'
    $P0['smolder_url'] = 'http://smolder.plusthree.com/app/public_projects/process_add_report/12'
    $P0['smolder_comments'] = 'parrot-lua'
    $S0 = get_tags()
    $P0['smolder_tags'] = $S0

    # install
    $P8 = split ' ', 'lua/lua.pbc lua/luad.pbc'
    $P0['inst_lang'] = $P8

    # dist
    $P1 = glob('luac2pir.pir test_lex.pir lua/lib/luabytecode.rules build/translator.pl lua/library/Test/More.lua t/lua-TestMore/test_lua51/*.t')
    $P0['manifest_includes'] = $P1
    $P2 = split ' ', 'lua/lib/luabytecode_gen.pir lua/library/Test/More.pir'
    $P0['manifest_excludes'] = $P2

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'update' :anon
    .param pmc kv :slurpy :named
    $I0 = file_exists('.git')
    unless $I0 goto L1
    system('git submodule update')
  L1:
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

    $I0 = file_exists('.git')
    unless $I0 goto L2
    $I0 = file_exists('t/lua-TestMore/src/Test/More.lua')
    if $I0 goto L2
    system('git submodule init t/lua-TestMore')
    system('git submodule update')
  L2:

    $I0 = newer('lua/library/Test/More.lua', 't/lua-TestMore/src/Test/More.lua')
    if $I0 goto L3
    install('t/lua-TestMore/src/Test/More.lua', 'lua/library/Test/More.lua')
  L3:
.end

.sub 'clean' :anon
    .param pmc kv :slurpy :named
    unlink('lua/lib/luabytecode_gen.pir')
    unlink('lua/library/Test/More.lua')
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
    run_step('set_LUA_INIT', kv :flat :named)

    .local string cmd
    cmd = "prove --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " lua.pbc\" t/lua-TestMore/test_lua51/*.t"
    system(cmd)
.end

.sub 'get_tags'
    .local string tags
    .local pmc config
    config = get_config()
    tags = config['osname']
    tags .= ", "
    $S0 = config['archname']
    tags .= $S0
    tags .= ", parrot-lua, Lua 5.1 (on Parrot)"
    .return (tags)
.end

.sub 'set_LUA_INIT' :anon
    .param pmc kv :slurpy :named
    .local pmc config
    config = get_config()
    .local string value
    value = "platform = { lua=[["
    $S0 = get_parrot()
    value .= $S0
    value .= " lua.pbc]], osname=[["
    $S0 = config['osname']
    value .= $S0
    value .= "]], intsize="
    $S0 = config['intsize']
    value .= $S0
    value .= ", longsize="
    $S0 = config['longsize']
    value .= $S0
    value .= " }"
    setenv('LUA_INIT', value)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
