# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Lua 5.1 VM bytecode to Parrot PIR Translator

=head2 Synopsis

 parrot luac2pir.pir file.luac

=head2 Description

B<luac2pir> translates a Lua 5.1 VM bytecode file to Parrot PIR.

=head2 See Also

luad

=cut

.loadlib 'lua_group'

.sub 'main' :main
    .param pmc argv
    .local int argc
    .local string progname
    .local string filename
    .local string content
    argc = elements argv
    if argc != 2 goto USAGE
    progname = shift argv
    filename = shift argv
    push_eh _handler
    content = load_file(filename)
    .local pmc script
    new $P0, 'LuaBytecode'
    script = $P0.'undump'(content)
    .local string gen_pir
    gen_pir = script.'translate'()
    save_pir(gen_pir, filename)
    pop_eh
    end
  USAGE:
    .local pmc stderr
    stderr = getstderr
    print stderr, "Usage: parrot luac2pir.pir filename\n"
    exit -1
  _handler:
    .local pmc e
    .local string msg
    .get_results (e)
    msg = e
    say msg
    end
.end

.sub 'load_file' :anon
    .param string filename
    .local pmc fh
    .local string content
    fh = new 'FileHandle'
    fh.'encoding'('binary')
    push_eh _handler
    content = fh.'readall'(filename)
    pop_eh
    .return (content)
  _handler:
    .local pmc e
    .get_results (e)
    $S0 = "Can't slurp '"
    $S0 .= filename
    $S0 .= "' ("
    $S1 = err
    $S0 .= $S1
    $S0 .= ")\n"
    e = $S0
    rethrow e
.end

.sub 'save_pir'
    .param string gen_pir
    .param string filename
    .local string output
    .local pmc fh
    fh = new 'FileHandle'
    output = concat filename, '.pir'
    push_eh _handler
    fh.'open'(output, 'w')
    pop_eh
    fh.'print'(gen_pir)
    fh.'close'()
    .return ()
  _handler:
    .local pmc e
    .get_results (e)
    $S0 = "Can't open '"
    $S0 .= output
    $S0 .= "' ("
    $S1 = err
    $S0 .= $S1
    $S0 .= ")\n"
    e = $S0
    rethrow e
.end

.include 'lua/lib/luabytecode.pir'


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
