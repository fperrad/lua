#! /usr/local/bin/parrot
# Copyright (C) 2007-2009, Parrot Foundation.
# $Id$

=head1 Lua lexicography test

=head2 Synopsis

    % parrot t/test_lex.t

=head2 Description

Tests Lua lexicograaphy
(implemented in F<test_lex.pir>).

See "Lua 5.1 Reference Manual", section 2.1 "Lexical Conventions",
L<http://www.lua.org/manual/5.1/manual.html#2.1>.

=cut

.sub 'main' :main
    .include 'test_more.pir'

    plan(23)

    test_hello()
    test_name()
    test_keyword()
    test_not_keyword()
    test_string()
    test_unfinished_string()
    test_string_with_escape_sequence_too_large()
    test_long_string()
    test_invalid_long_string_delimiter()
    test_string_with_escape_sequence_too_large()
    test_nested_long_string()
    test_number()
    test_malformed_number_1()
    test_malformed_number_2()
    test_malformed_number_3()
    test_comment()
    test_long_comment()
    test_not_long_comment()
    test_unfinished_long_comment()
    test_nested_long_comment()
    test_syntax_error()
    test_shebang()
    test_shebang_misplaced()

    # clean up
    $P0 = new 'OS'
    $P0.'rm'('test_lex.lua')
.end

.sub 'lua_lex' :anon
    .param string code
    spew('test_lex.lua', code)
    $P0 = open 'parrot test_lex.pir test_lex.lua', 'rp'
    $S0 = $P0.'readall'()
    close $P0
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

.sub 'test_hello'
    $S0 = lua_lex(<<'CODE')
print("hello")
CODE
    is($S0, <<'OUT', "hello")
Name:	print
punct:	(
String:	hello
punct:	)
OUT
.end

.sub 'test_name'
    $S0 = lua_lex(<<'CODE')
i       j       i10     _ij     _
aSomewhatLongName       _INPUT
CODE
    is($S0, <<'OUT', "name")
Name:	i
Name:	j
Name:	i10
Name:	_ij
Name:	_
Name:	aSomewhatLongName
Name:	_INPUT
OUT
.end

.sub 'test_keyword'
    $S0 = lua_lex(<<'CODE')
and
break
do
else
elseif
end
false
for
function
if
in
local
nil
not
or
repeat
return
then
true
until
while
CODE
    is($S0, <<'OUT', "keyword")
keyword:	and
keyword:	break
keyword:	do
keyword:	else
keyword:	elseif
keyword:	end
keyword:	false
keyword:	for
keyword:	function
keyword:	if
keyword:	in
keyword:	local
keyword:	nil
keyword:	not
keyword:	or
keyword:	repeat
keyword:	return
keyword:	then
keyword:	true
keyword:	until
keyword:	while
OUT
.end

.sub 'test_not_keyword'
    $S0 = lua_lex(<<'CODE')
format      -- not for
doit        -- not do
CODE
    is($S0, <<'OUT', "not keyword")
Name:	format
Name:	doit
OUT
.end

.sub 'test_string'
    $S0 = lua_lex(<<'CODE')
'alo\n123"'
"alo\n123\""
'\97lo\10\04923"'
CODE
    is($S0, <<'OUT', "string")
String:	alo
123"
String:	alo
123"
String:	alo
123"
OUT
.end

.sub 'test_unfinished_string'
    $S0 = lua_lex(<<'CODE')
print "unfinished string
CODE
    # /^[^:]+:1: unfinished string near '"?unfinished string'/
    like($S0, ":s unfinished string near", "unfinished string")
.end

.sub 'test_string_with_escape_sequence_too_large'
    $S0 = lua_lex(<<'CODE')
print "escape\333sequence"
CODE
    # /^[^:]+:1: escape sequence too large near '"?escape/
    like($S0, ":s escape sequence too large near", "string with escape sequence too large")
.end

.sub 'test_long_string'
    $S0 = lua_lex(<<'CODE')
[[alo
123"]]
[==[
alo
123"]==]
CODE
    is($S0, <<'OUT', "long string")
LongString:	alo
123"
LongString:	alo
123"
OUT
.end

.sub 'test_invalid_long_string_delimiter'
    $S0 = lua_lex(<<'CODE')
print [===+ string ]===]
CODE
    # /^[^:]+:1: invalid long string delimiter near '\[==='/
    like($S0, ":s invalid long string delimiter near", "invalid long string delimiter")
.end

.sub 'test_unfinished_long_string'
    $S0 = lua_lex(<<'CODE')
print [[unfinished long string

CODE
    # /^[^:]+:1: unfinished long string/
    like($S0, ":s unfinished long string", "unfinished long string")
.end

.sub 'test_nested_long_string'
    $S0 = lua_lex(<<'CODE')
print [[ long string [[ nested ]] ]]

CODE
    # /^[^:]+:1: nesting of \[\[\.\.\.\]\] is deprecated near '\[\[ long string \[\['/
    like($S0, ":s is deprecated near", "nested long string")
.end

.sub 'test_number'
    $S0 = lua_lex(<<'CODE')
3
3.0
3.1416
314.16e-2
0.31416E1
.31416E+1
0xff
0x56
CODE
    is($S0, <<'OUT', "number")
Number:	3
Number:	3.0
Number:	3.1416
Number:	314.16e-2
Number:	0.31416E1
Number:	.31416E+1
Number:	0xff
Number:	0x56
OUT
.end

.sub 'test_malformed_number_1'
    $S0 = lua_lex(<<'CODE')
0x1Bh
CODE
    # /^[^:]+:1: malformed number near '0x1Bh'/
    like($S0, ":s malformed number near", "malformed number")
.end

.sub 'test_malformed_number_2'
    $S0 = lua_lex(<<'CODE')
1.2.34
CODE
    # /^[^:]+:1: malformed number near '1.2.34'/
    like($S0, ":s malformed number near", "malformed number")
.end

.sub 'test_malformed_number_3'
    $S0 = lua_lex(<<'CODE')
.2A
CODE
    # /^[^:]+:1: malformed number near '.2A'/
    like($S0, ":s malformed number near", "malformed number")
.end

.sub 'test_comment'
    $S0 = lua_lex(<<'CODE')
-- comment
1   -- comment
2
CODE
    is($S0, <<'OUT', "comment")
Number:	1
Number:	2
OUT
.end

.sub 'test_long_comment'
    $S0 = lua_lex(<<'CODE')
--[[
    long comment
]]
1
--[===[
    long comment
]===]
CODE
    is($S0, <<'OUT', "long comment")
Number:	1
OUT
.end

.sub 'test_not_long_comment'
    $S0 = lua_lex(<<'CODE')
--[[
    no action (comment)
--]]
1
---[[
    active
--]]
CODE
    is($S0, <<'OUT', "not long comment")
Number:	1
Name:	active
OUT
.end

.sub 'test_unfinished_long_comment'
    $S0 = lua_lex(<<'CODE')
 --[[unfinished long comment

CODE
    # /^[^:]+:1: unfinished long comment/
    like($S0, ":s unfinished long comment", "unfinished long comment")
.end

.sub 'test_nested_long_comment'
    $S0 = lua_lex(<<'CODE')
--[[ long comment [[ nested ]] ]]

CODE
    # /^[^:]+:1: nesting of \[\[\.\.\.\]\] is deprecated near '\[\[ long comment \[\['/
    like($S0, ":s is deprecated near", "nested long comment")
.end

.sub 'test_syntax_error'
    $S0 = lua_lex(<<'CODE')
!!
CODE
    # /^[^:]+:1: syntax error/
    like($S0, ":s syntax error", "syntax error")
.end

.sub 'test_shebang'
    $S0 = lua_lex(<<'CODE')
#!/usr/bin/env lua
1
CODE
    is($S0, <<'OUT', "shebang")
Number:	1
OUT
.end

.sub 'test_shebang_misplaced'
    $S0 = lua_lex(<<'CODE')

#!/usr/bin/env lua
1
CODE
    # /^[^:]+:1: syntax error/
    like($S0, ":s syntax error", "shebang misplaced")
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
