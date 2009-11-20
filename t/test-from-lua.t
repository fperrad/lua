#! /usr/local/bin/parrot
# Copyright (C) 2007-2009, Parrot Foundation.
# $Id$

=head1 simple tests from Lua distribution

=head2 Synopsis

    % parrot t/test-from-lua.t

=head2 Description

These are simple tests for Lua.  Some of them contain useful code.
They are meant to be run to make sure Lua is built correctly and also
to be read, to see how Lua programs look.

Here is a one-line summary of each program:

   bisect.lua           bisection method for solving non-linear equations
   cf.lua               temperature conversion table (celsius to farenheit)
   echo.lua             echo command line arguments
   env.lua              environment variables as automatic global variables
   factorial.lua        factorial without recursion
   fib.lua              fibonacci function with cache
   fibfor.lua           fibonacci numbers with coroutines and generators
   globals.lua          report global variable usage
   hello.lua            the first program in every language
   life.lua             Conway's Game of Life
   luac.lua             bare-bones luac
   printf.lua           an implementation of printf
   readonly.lua         make global variables readonly
   sieve.lua            the sieve of of Eratosthenes programmed with coroutines
   sort.lua             two implementations of a sort function
   table.lua            make table, grouping all data for the same item
   trace-calls.lua      trace calls
   trace-globals.lua    trace assigments to global variables
   xd.lua               hex dump

=cut

.sub 'main' :main
    .include 'test_more.pir'

    plan(6)

    test_bisect()
    test_cf()
    test_factorial()
    test_fibfor()
    test_sieve()
    test_sort()
.end

.sub 'lua' :anon
    .param string filename
    .local string cmd
    cmd = "parrot lua.pbc " . filename
    $P0 = open cmd, 'rp'
    $S0 = $P0.'readall'()
    close $P0
    .return ($S0)
.end

.sub 'slurp' :anon
    .param string filename
    $P0 = new 'FileHandle'
    push_eh _handler
    $S0 = $P0.'readall'(filename)
    pop_eh
    $P0 = split "\r\n", $S0 # hack from win32
    $S1 = join "\n", $P0
    .return ($S1)
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

#
#   bisect.lua
#       bisection method for solving non-linear equations
#

.include 'iglobals.pasm'

.sub 'test_bisect'
    .local pmc config
    $P0 = getinterp
    config = $P0[.IGLOBALS_CONFIG_HASH]
    .local string osname
    osname = config['osname']
    $S0 = lua('t/test/bisect.lua')
    unless osname == 'MSWin32' goto L1
    $S1 = slurp('t/test/bisect-output-win32.txt')
    $I0 = $S0 == $S1
    todo($I0, "bisect", "floating point format")
    goto L2
  L1:
    $S1 = slurp('t/test/bisect-output-unix.txt')
    is($S0, $S1, "bisect")
  L2:
.end

#
#   cf.lua
#       temperature conversion table (celsius to farenheit)
#

.sub 'test_cf'
    $S0 = lua('t/test/cf.lua')
    $S1 = slurp('t/test/cf-output.txt')
    is($S0, $S1, "cf")
.end

#
#   factorial.lua
#       factorial without recursion
#

.sub 'test_factorial'
    $S0 = lua('t/test/factorial.lua')
    $S1 = slurp('t/test/factorial-output.txt')
    is($S0, $S1, "factorial")
.end

#
#   fibfor.lua
#       fibonacci numbers with coroutines and generators
#

.sub 'test_fibfor'
    $S0 = lua('t/test/fibfor.lua')
    $S1 = slurp('t/test/fibfor-output.txt')
    is($S0, $S1, "fibfor")
.end

#
#   sieve.lua
#       the sieve of of Eratosthenes programmed with coroutines
#

.sub 'test_sieve'
    $S0 = lua('t/test/sieve.lua')
    $S1 = slurp('t/test/sieve-output.txt')
    is($S0, $S1, "sieve")
.end

#
#   sort.lua
#       two implementations of a sort function
#

.sub 'test_sort'
    $S0 = lua('t/test/sort.lua')
    $S1 = slurp('t/test/sort-output.txt')
    is($S0, $S1, "sort")
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
