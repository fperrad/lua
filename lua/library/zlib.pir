# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 LuaZlib

=head2 Description

LuaZlib is a simple binding to the zlib library (http://www.zlib.net).

Currently, only the compress/uncompress functions have been implemented.

See original on L<http://luaforge.net/projects/luazlib/>

=head3 Functions

=over 4

=cut

.HLL 'lua'
.loadlib 'lua_group'
.namespace [ 'zlib' ]

.sub '__onload' :anon :load
#    print "__onload zlib\n"
    .const 'Sub' entry = 'luaopen_zlib'
    set_hll_global 'luaopen_zlib', entry
.end

.sub 'luaopen_zlib'

#    print "luaopen_zlib\n"

    .local pmc _lua__GLOBAL
    _lua__GLOBAL = get_hll_global '_G'

    new $P1, 'LuaString'

    .local pmc _zlib
    new _zlib, 'LuaTable'
    set $P1, 'zlib'
    _lua__GLOBAL[$P1] = _zlib

    $P2 = split "\n", <<'LIST'
compress
uncompress
gzuncompress
LIST
    lua_register($P1, _zlib, $P2)

    new $P2, 'LuaString'

    set $P2, "Copyright (C) 2009, Parrot Foundation"
    set $P1, "_COPYRIGHT"
    _zlib[$P1] = $P2

    set $P2, "Binding to the zlib library"
    set $P1, "_DESCRIPTION"
    _zlib[$P1] = $P2

    set $P2, "LuaZlib 1.0.0"
    set $P1, "_VERSION"
    _zlib[$P1] = $P2

    .return (_zlib)
.end


=item C<zlib.compress (src)>

=cut

.sub 'compress'
    .param pmc src
    .param pmc extra :slurpy
    .local pmc res
    $S1 = lua_checkstring(1, src)

    new res, 'LuaString'
    set res, $S0
    .return (res)
.end


=item C<zlib.uncompress (src)>

=cut

.sub 'uncompress'
    .param pmc src
    .param pmc extra :slurpy
    .local pmc res
    $S1 = lua_checkstring(1, src)

    new res, 'LuaString'
    set res, $S0
    .return (res)
.end


=item C<zlib.gzuncompress (src)>

=cut

.sub 'gzuncompress'
    .param pmc src
    .param pmc extra :slurpy
    .local pmc res
    $S1 = lua_checkstring(1, src)

    new res, 'LuaString'
    set res, $S0
    .return (res)
.end


=back

=cut


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
