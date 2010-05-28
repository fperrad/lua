#! /usr/local/bin/parrot
# Copyright (C) 2006-2009, Parrot Foundation.
# $Id$

=head1 Lua lexicography

=head2 Synopsis

    % parrot t/lexico.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.1 "Lexical Conventions",
L<http://www.lua.org/manual/5.1/manual.html#2.1>.

=cut

.sub 'main' :main
    $P0 = loadlib 'os'
    .include 'test_more.pir'

    plan(3)

    test_string()
    test_number()
    test_escape_character()

    # clean up
    $P0 = new 'OS'
    $P0.'rm'('lexico.lua')
.end

.sub 'lexico' :anon
    .param string code
    spew('lexico.lua', code)
    $P0 = new 'FileHandle'
    $P0.'open'('parrot lua.pbc lexico.lua', 'rp')
    $S0 = $P0.'readall'()
    $P0.'close'()
    .return ($S0)
.end

.sub 'spew' :anon
    .param string filename
    .param string content
    $P0 = new 'FileHandle'
    push_eh _handler
    $P0.'open'(filename, 'w')
    pop_eh
    $P0.'puts'(content)
    $P0.'close'()
    .return ()
  _handler:
    .local pmc e
    .get_results (e)
    $S0 = "Can't open '"
    $S0 .= filename
    $S0 .= "' ("
    $S1 = err
    $S0 .= $S1
    $S0 .= ")\n"
    e = $S0
    rethrow e
.end

.sub 'test_string'
    $S0 = lexico(<<'CODE')
print 'alo\n123"'
print "alo\n123\""
print '\97lo\10\04923"'
print [[alo
123"]]
print [[
alo
123"]]
print [==[
alo
123"]==]
CODE
    is($S0, <<'OUT', "string")
alo
123"
alo
123"
alo
123"
alo
123"
alo
123"
alo
123"
OUT
.end

.sub 'test_number'
    $S0 = lexico(<<'CODE')
print(3)
print(3.0)
print(3.1416)
print(314.16e-2)
print(0.31416E1)
print(0xff)
print(0x56)
CODE
    is($S0, <<'OUT', "number")
3
3
3.1416
3.1416
3.1416
255
86
OUT
.end

.sub 'test_escape_character'
    $S0 = lexico(<<'CODE')
print("\n")
print("\"")
CODE
    is($S0, <<'OUT', "escape character")


"
OUT
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
