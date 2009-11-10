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

    .const 'Sub' testclean = 'testclean'
    register_step_after('test', testclean)

    .const 'Sub' pmctest = 'pmctest'
    register_step('pmctest', pmctest)

    .const 'Sub' sanity = 'sanity'
    register_step('sanity', sanity)

    .const 'Sub' spectest = 'spectest'
    register_step('spectest', spectest)

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
    $P5['lua/library/_helpers.pbc'] = 'lua/library/_helpers.pir'
    $P5['lua/library/alarm.pbc'] = 'lua/library/alarm.pir'
    $P5['lua/library/base64.pbc'] = 'lua/library/base64.pir'
    $P5['lua/library/bc.pbc'] = 'lua/library/bc.pir'
    $P5['lua/library/bit.pbc'] = 'lua/library/bit.pir'
    $P5['lua/library/bitlib.pbc'] = 'lua/library/bitlib.pir'
    $P5['lua/library/complex.pbc'] = 'lua/library/complex.pir'
#    $P5['lua/library/gl.pbc'] = 'lua/library/gl.pir' # gl.lua
    $P5['lua/library/gl_binding.pbc'] = 'lua/library/gl_binding.pir'
    $P5['lua/library/glut.pbc'] = 'lua/library/glut.pir'
    $P5['lua/library/lfs.pbc'] = 'lua/library/lfs.pir'
    $P5['lua/library/lpeg.pbc'] = 'lua/library/lpeg.pir'
    $P5['lua/library/markdown.pbc'] = 'lua/library/markdown.pir'
    $P5['lua/library/mathx.pbc'] = 'lua/library/mathx.pir'
    $P5['lua/library/md5.pbc'] = 'lua/library/md5.pir'
    $P5['lua/library/random.pbc'] = 'lua/library/random.pir'
    $P5['lua/library/sha1.pbc'] = 'lua/library/sha1.pir'
    $P5['lua/library/struct.pbc'] = 'lua/library/struct.pir'
    $P5['lua/library/uuid.pbc'] = 'lua/library/uuid.pir'
    $P5['lua/library/zlib.pbc'] = 'lua/library/zlib.pir'
    $P0['pbc_pir'] = $P5

    $P7 = new 'Hash'
    $P7['parrot-lua'] = 'lua.pbc'
    $P7['parrot-luap'] = 'luap.pbc'
    $P0['exe_pbc'] = $P7

    # install
    $P8 = split "\n", <<'LIBS'
lua/lua.pbc
lua/luad.pbc
lua/library/_helpers.pbc
lua/library/alarm.pbc
lua/library/base64.pbc
lua/library/bc.pbc
lua/library/bit.pbc
lua/library/bitlib.pbc
lua/library/complex.pbc
lua/library/gl_binding.pbc
lua/library/glut.pbc
lua/library/lfs.pbc
lua/library/lpeg.pbc
lua/library/markdown.pbc
lua/library/mathx.pbc
lua/library/md5.pbc
lua/library/random.pbc
lua/library/sha1.pbc
lua/library/struct.pbc
lua/library/uuid.pbc
lua/library/zlib.pbc
LIBS
    $S0 = pop $P8
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

    $I0 = newer('lua/library/sha1.pir', 'lua/library/md5.pir')
    if $I0 goto L2
    cmd = 'perl -pe "s|md5|sha1|g; s|MD5|SHA1|g" lua/library/md5.pir > lua/library/sha1.pir'
    system(cmd)
  L2:
.end

.sub 'clean' :anon
    .param pmc kv :slurpy :named
    unlink('lua/lib/luabytecode_gen.pir')
    unlink('lua/library/sha1.pir')
.end

.sub 'testclean' :anon
    .param pmc kv :slurpy :named
    system("perl -MExtUtils::Command -e rm_f t/*.lua t/*.parrot_out")
.end

.sub 'pmctest'
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)
    .local string cmd
    cmd = "prove --exec="
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " t/pmc/*.t"
    system(cmd)
.end

.sub 'spectest'
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    .local string current_dir
    current_dir = cwd()
    chdir('t/lua-TestMore/test_lua51')

    setenv('LUA_PATH', ";;..\src\?.lua")
    setenv('LUA_INIT', "platform = { osname=[[MSWin32]], intsize=4, longsize=4 }")

    .local string cmd
    cmd = "prove --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " ../../../lua.pbc\" *.t"
    system(cmd)

    chdir(current_dir)
.end

.sub 'sanity'
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    .local string current_dir
    current_dir = cwd()
    chdir('t/lua-TestMore/test_lua51')

    .local string cmd
    cmd = "prove --exec=\""
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " ../../../lua.pbc\" 0*.t"
    system(cmd)

    chdir(current_dir)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
