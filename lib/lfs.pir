# Copyright (C) 2007, The Perl Foundation.
# $Id$

=head1 NAME

lib/lfs.pir - Lua File System Library v1.2

=head1 DESCRIPTION

LuaFileSystem is a Lua library developed to complement the set of functions
related to file systems offered by the standard Lua distribution.

LuaFileSystem offers a portable way to access the underlying directory
structure and file attributes.

See original on L<http://luaforge.net/projects/luafilesystem/>

=head2 Functions

=over 4

=cut

.HLL 'Lua', 'lua_group'

.sub '__onload' :anon :load
#    print "__onload lfs\n"
    .const .Sub entry = 'luaopen_lfs'
    set_root_global 'luaopen_lfs', entry
.end

.sub 'luaopen_lfs'

#    print "luaopen_lfs\n"

    .local pmc _lua__GLOBAL
    _lua__GLOBAL = global '_G'

    new $P1, .LuaString

    .local pmc _lfs
    new _lfs, .LuaTable
    set $P1, 'lfs'
    _lua__GLOBAL[$P1] = _lfs

    _register($P1, _lfs)

    .const .Sub _lfs_attributes = '_lfs_attributes'
    _lfs_attributes.'setfenv'(_lua__GLOBAL)
    set $P1, 'attributes'
    _lfs[$P1] = _lfs_attributes

    .const .Sub _lfs_chdir = '_lfs_chdir'
    _lfs_chdir.'setfenv'(_lua__GLOBAL)
    set $P1, 'chdir'
    _lfs[$P1] = _lfs_chdir

    .const .Sub _lfs_currentdir = '_lfs_currentdir'
    _lfs_currentdir.'setfenv'(_lua__GLOBAL)
    set $P1, 'currentdir'
    _lfs[$P1] = _lfs_currentdir

    .const .Sub _lfs_dir = '_lfs_dir'
    _lfs_dir.'setfenv'(_lua__GLOBAL)
    set $P1, 'dir'
    _lfs[$P1] = _lfs_dir

    .const .Sub _lfs_lock = '_lfs_lock'
    _lfs_lock.'setfenv'(_lua__GLOBAL)
    set $P1, 'lock'
    _lfs[$P1] = _lfs_lock

    .const .Sub _lfs_mkdir = '_lfs_mkdir'
    _lfs_mkdir.'setfenv'(_lua__GLOBAL)
    set $P1, 'mkdir'
    _lfs[$P1] = _lfs_mkdir

    .const .Sub _lfs_rmdir = '_lfs_rmdir'
    _lfs_rmdir.'setfenv'(_lua__GLOBAL)
    set $P1, 'rmdir'
    _lfs[$P1] = _lfs_rmdir

    .const .Sub _lfs_touch = '_lfs_touch'
    _lfs_touch.'setfenv'(_lua__GLOBAL)
    set $P1, 'touch'
    _lfs[$P1] = _lfs_touch

    .const .Sub _lfs_unlock = '_lfs_unlock'
    _lfs_unlock.'setfenv'(_lua__GLOBAL)
    set $P1, 'unlock'
    _lfs[$P1] = _lfs_unlock


    new $P2, .LuaString

    set $P2, "Copyright (C) 2007, The Perl Foundation"
    set $P1, "_COPYRIGHT"
    _lfs[$P1] = $P2

    set $P2, "LuaFileSystem is a Lua library developed to complement the set of functions related to file systems offered by the standard Lua distribution"
    set $P1, "_DESCRIPTION"
    _lfs[$P1] = $P2

    set $P2, "LuaFileSystem 1.2"
    set $P1, "_VERSION"
    _lfs[$P1] = $P2

    .return (_lfs)
.end

.sub 'check_file' :anon
    .param pmc fh
    .param string funcname
    .local pmc ret
    checkudata(fh, 'ParrotIO')
    ret =  getattribute fh, 'data'
    unless null ret goto L1
    $S0 = concat funcname, ": closed file"
    error($S0)
L1:
    .return (ret)
.end

=item C<lfs.attributes (filepath [, aname])>

Returns a table with the file attributes corresponding to C<filepath> (or
C<nil> followed by an error message in case of error). If the second optional
argument is given, then only the value of the named attribute is returned
(this use is equivalent to C<lfs.attributes(filepath).aname>, but the table
is not created and only one attribute is retrieved from the O.S.). The
attributes are described as follows; attribute C<mode> is a string, all the
others are numbers, and the time related attributes use the same time
reference of C<os.time>:

=over 4

=item B<"dev">

on Unix systems, this represents the device that the inode resides on.
On Windows systems, represents the drive number of the disk containing the file

=item B<"ino">

on Unix systems, this represents the inode number.
On Windows systems this has no meaning

=item B<"mode">

string representing the associated protection mode (the values could be
C<file>, C<directory>, C<link>, C<socket>, C<named pipe>, C<char device>,
C<block device> or C<other>)

=item B<"nlink">

number of hard links to the file

=item B<"uid">

user-id of owner (Unix only, always 0 on Windows)

=item B<"gid">

group-id of owner (Unix only, always 0 on Windows)

=item B<"rdev">

on Unix systems, represents the device type, for special file inodes.
On Windows systems represents the same as dev

=item B<"access">

time of last access

=item B<"modification">

time of last data modification

=item B<"changes">

time of last file status change

=item B<"size">

file size, in bytes

=item B<"blocks">

block allocated for file; (Unix only)

=item B<"blksize">

optimal file system I/O blocksize; (Unix only)

=back

=cut

.sub '_lfs_attributes' :anon
    .param pmc filepath :optional
    .param pmc aname :optional
    .local pmc ret
    .local pmc members
    .local pmc opts
    $S1 = checkstring(filepath)
    $S0 = $S1
    new opts, .FixedStringArray
    set opts, 13
    opts[0] = 'mode'
    opts[1] = 'dev'
    opts[2] = 'ino'
    opts[3] = 'nlink'
    opts[4] = 'uid'
    opts[5] = 'gid'
    opts[6] = 'rdev'
    opts[7] = 'access'
    opts[8] = 'modification'
    opts[9] = 'change'
    opts[10] = 'size'
    opts[11] = 'blocks'
    opts[12] = 'blksize'
    new members, .FixedPMCArray
    set members, 13
    .const .Sub st_mode = 'st_mode'
    members[0] = st_mode
    .const .Sub st_dev = 'st_dev'
    members[1] = st_dev
    .const .Sub st_ino = 'st_ino'
    members[2] = st_ino
    .const .Sub st_nlink = 'st_nlink'
    members[3] = st_nlink
    .const .Sub st_uid = 'st_uid'
    members[4] = st_uid
    .const .Sub st_gid = 'st_gid'
    members[5] = st_gid
    .const .Sub st_rdev = 'st_rdev'
    members[6] = st_rdev
    .const .Sub st_atime = 'st_atime'
    members[7] = st_atime
    .const .Sub st_mtime = 'st_mtime'
    members[8] = st_mtime
    .const .Sub st_ctime = 'st_ctime'
    members[9] = st_ctime
    .const .Sub st_size = 'st_size'
    members[10] = st_size
    .const .Sub st_blocks = 'st_blocks'
    members[11] = st_blocks
    .const .Sub st_blksize = 'st_blksize'
    members[12] = st_blksize
    new $P0, .OS
    push_eh _handler
    $P1 = $P0.'stat'($S1)
    clear_eh
    if null aname goto L1
    $I0 = isa aname, 'LuaString'
    unless $I0 goto L2
    $S2 = aname
    $I2 = checkoption($S2, opts)
    $P2 = members[$I2]
    ret = $P2($P1)
    .return (ret)
L2:
    $I0 = isa aname, 'LuaTable'
    unless $I0 goto L1
    ret = aname
    goto L3
L1:
    new ret, .LuaTable
L3:
    new $P2, .LuaString
    $I0 = 0
L4:
    unless $I0 < 13 goto L5
    $P3 = members[$I0]
    $P4 = $P3($P1)
    $S2 = opts[$I0]
    set $P2, $S2
    ret[$P2] = $P4
    inc $I0
    goto L4
L5:
    .return (ret)
_handler:
    .local pmc nil
    .local pmc msg
    new nil, .LuaNil
    new msg, .LuaString
    $S0 = concat "cannot obtain information from file `", $S0
    $S0 = concat "'"
    set msg, $S0
    .return (nil, msg)
.end

.sub st_dev :anon
    .param pmc st
    $I0 = st[0]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_ino :anon
    .param pmc st
    $I0 = st[1]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.const int S_IFIFO  = 0x1000    # named pipe (fifo)
.const int S_IFCHR  = 0x2000    # character special
.const int S_IFDIR  = 0x4000    # directory
.const int S_IFBLK  = 0x6000    # block special
.const int S_IFREG  = 0x8000    # regular
.const int S_IFLNK  = 0xA000    # symbolic link
.const int S_IFSOCK = 0xC000    # socket

.const int S_IFMT   = 0xF000    # type of file mask

.sub st_mode :anon
    .param pmc st
    $I0 = st[2]
    $I0 &= S_IFMT
    new $P0, .LuaString
    unless $I0 == S_IFREG goto L1
    set $P0, 'file'
    .return ($P0)
L1:
    unless $I0 == S_IFDIR goto L2
    set $P0, 'dir'
    .return ($P0)
L2:
    unless $I0 == S_IFLNK goto L3
    set $P0, 'link'
    .return ($P0)
L3:
    unless $I0 == S_IFSOCK goto L4
    set $P0, 'socket'
    .return ($P0)
L4:
    unless $I0 == S_IFIFO goto L5
    set $P0, 'named pipe'
    .return ($P0)
L5:
    unless $I0 == S_IFCHR goto L6
    set $P0, 'char device'
    .return ($P0)
L6:
    unless $I0 == S_IFBLK goto L7
    set $P0, 'block device'
    .return ($P0)
L7:
    set $P0, 'other'
    .return ($P0)
.end

.sub st_nlink :anon
    .param pmc st
    $I0 = st[3]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_uid :anon
    .param pmc st
    $I0 = st[4]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_gid :anon
    .param pmc st
    $I0 = st[5]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_rdev :anon
    .param pmc st
    $I0 = st[6]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_size :anon
    .param pmc st
    $I0 = st[7]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_atime :anon
    .param pmc st
    $I0 = st[8]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_mtime :anon
    .param pmc st
    $I0 = st[9]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_ctime :anon
    .param pmc st
    $I0 = st[10]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
.end

.sub st_blksize :anon
    .param pmc st
    $I0 = exists st[11]
    unless $I0 goto L1
    $I0 = st[11]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
L1:
    new $P0, .LuaNil
    .return ($P0)
.end

.sub st_blocks :anon
    .param pmc st
    $I0 = exists st[12]
    unless $I0 goto L1
    $I0 = st[12]
    new $P0, .LuaNumber
    set $P0, $I0
    .return ($P0)
L1:
    new $P0, .LuaNil
    .return ($P0)
.end


=item C<lfs.chdir (path)>

Changes the current working directory to the given C<path>.

Returns C<true> in case of success or C<nil> plus an error string.

=cut

.sub '_lfs_chdir' :anon
    .param pmc path :optional
    .local pmc ret
    $S1 = checkstring(path)
    $S0 = $S1
    new $P0, .OS
    push_eh _handler
    $P0.'chdir'($S1)
    new ret, .LuaBoolean
    set ret, 1
    .return (ret)
_handler:
    .local pmc nil
    .local pmc msg
    .local pmc e
    .local string s
    .get_results (e, s)
    new nil, .LuaNil
    new msg, .LuaString
    $S0 = concat "Unable to change working directory to '", $S0
    $S0 = concat "'\n"
    $S0 = concat s
    $S0 = concat "\n"
    set msg, $S0
    .return (nil, msg)
.end


=item C<lfs.currentdir ()>

Returns a string with the current working directory or C<nil> plus an error
string.

=cut

.sub '_lfs_currentdir' :anon
    .local pmc ret
    new $P0, .OS
    push_eh _handler
    $S0 = $P0.'cwd'()
    new ret, .LuaString
    set ret, $S0
    .return (ret)
_handler:
    .local pmc nil
    .local pmc msg
    .local pmc e
    .local string s
    .get_results (e, s)
    new nil, .LuaNil
    new msg, .LuaString
    set msg, s
    .return (nil, msg)
.end


=item C<lfs.dir (path)>

Lua iterator over the entries of a given directory. Each time the iterator is
called it returns a string with an entry of the directory; C<nil> is returned
when there is no more entries. Raises an error if C<path> is not a directory.

=cut

.sub '_lfs_dir' :anon
    .param pmc path :optional
    .local pmc ret
    $S1 = checkstring(path)
    $S0 = $S1
    new $P0, .OS
    push_eh _handler
    $P1 = $P0.'readdir'($S1)
    .lex 'upvar_dir', $P1
    .const .Sub dir_aux = 'dir_aux'
    ret = newclosure dir_aux
    .return (ret)
_handler:
    .local pmc e
    .local string s
    .get_results (e, s)
    $S0 = concat "cannot open ", $S0
    $S0 = concat ": "
    $S0 = concat s
    error($S0)
.end

.sub 'dir_aux' :anon :lex :outer(_lfs_dir)
    .local pmc ret
    $P1 = find_lex 'upvar_dir'
    unless $P1 goto L1
    $S1 = shift $P1
    new ret, .LuaString
    set ret, $S1
    .return (ret)
L1:
    new ret, .LuaNil
    .return (ret)
.end


=item C<lfs.lock (filehandle, mode[, start[, length]])>

Locks a file or a part of it. This function works on I<open files>; the file
handle should be specified as the first argument. The string C<mode> could be
either C<r> (for a read/shared lock) or C<w> (for a write/exclusive lock).
The optional arguments C<start> and C<length> can be used to specify a
starting point and its length; both should be numbers.

Returns C<true> if the operation was successful; in case of error, it returns
C<nil> plus an error string.

NOT YET IMPLEMENTED.

=cut

.sub '_lfs_lock' :anon
    .param pmc filehandle :optional
    .param pmc mode :optional
    .param pmc start :optional
    .param pmc length :optional
    $P1 = check_file(filehandle, 'lock')
    $S2 = checkstring(mode)
    $I3 = optint(start, 0)
    $I4 = optint(length, 0)
    not_implemented()
.end


=item C<lfs.mkdir (dirname)>

Creates a new directory. The argument is the name of the new directory.

Returns C<true> if the operation was successful; in case of error, it returns
C<nil> plus an error string.

=cut

.sub '_lfs_mkdir' :anon
    .param pmc dirname :optional
    .local pmc ret
    $S1 = checkstring(dirname)
    new $P0, .OS
    push_eh _handler
    $I1 = 0o775
    $P0.'mkdir'($S1, $I1)
    new ret, .LuaBoolean
    set ret, 1
    .return (ret)
_handler:
    .local pmc nil
    .local pmc msg
    .local pmc e
    .local string s
    .get_results (e, s)
    new nil, .LuaNil
    new msg, .LuaString
    set msg, s
    .return (nil, msg)
.end


=item C<lfs.rmdir (dirname)>

Removes an existing directory. The argument is the name of the directory.

Returns C<true> if the operation was successful; in case of error, it returns
C<nil> plus an error string.

=cut

.sub '_lfs_rmdir' :anon
    .param pmc dirname :optional
    .local pmc ret
    $S1 = checkstring(dirname)
    new $P0, .OS
    push_eh _handler
    $P0.'rm'($S1)
    new ret, .LuaBoolean
    set ret, 1
    .return (ret)
_handler:
    .local pmc nil
    .local pmc msg
    .local pmc e
    .local string s
    .get_results (e, s)
    new nil, .LuaNil
    new msg, .LuaString
    set msg, s
    .return (nil, msg)
.end


=item C<lfs.touch (filepath [, atime [, mtime]])>

Set access and modification times of a file. This function is a bind to
C<utime> function. The first argument is the filename, the second argument
(C<atime>) is the access time, and the third argument (C<mtime>) is the
modification time. Both times are provided in seconds (which should be
generated with Lua standard function C<os.date>). If the modification time is
omitted, the access time provided is used; if both times are omitted, the
current time is used.

Returns C<true> if the operation was successful; in case of error, it returns
C<nil> plus an error string.

NOT YET IMPLEMENTED.

=cut

.sub '_lfs_touch' :anon
    .param pmc filepath :optional
    .param pmc atime :optional
    .param pmc mtime :optional
    $S1 = checkstring(filepath)
    not_implemented()
.end


=item C<lfs.unlock (filehandle[, start[, length]])>

Unlocks a file or a part of it. This function works on I<open files>; the file
handle should be specified as the first argument. The optional arguments
C<start> and C<length> can be used to specify a starting point and its length;
both should be numbers.

Returns C<true> if the operation was successful; in case of error, it returns
C<nil> plus an error string.

NOT YET IMPLEMENTED.

=cut

.sub '_lfs_unlock' :anon
    .param pmc filehandle :optional
    .param pmc start :optional
    .param pmc length :optional
    $P1 = check_file(filehandle, 'unlock')
    $I2 = optint(start, 0)
    $I3 = optint(length, 0)
    not_implemented()
.end

=back

=head1 AUTHORS

Francois Perrad

=cut


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4: