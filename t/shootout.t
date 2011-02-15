#! /usr/local/bin/parrot
# Copyright (C) 2007-2009, Parrot Foundation.
# $Id$

=head1 The Computer Language Shootout

=head2 Synopsis

    % parrot t/shootout.t

=head2 Description

See L<http://shootout.alioth.debian.org>.

=cut

.sub 'main' :main
    .include 'test_more.pir'

    unless 1 goto L1
    # skip_all("no shootout")
    print "1..0"
    print " # SKIP "
    print "no shootout"
    end
  L1:

    plan(19)

    test_k_nucleotide()
    test_partialsums()
    test_fasta()
    test_pidigits()
    test_nsieve()
    test_regexdna()
    test_nsievebits()
    test_recursive()
    test_mandelbrot()
    test_nbody()
    test_message()
    test_spectralnorm()
    test_chameneos()
    test_revcomp()
    test_binarytrees()
    test_fannkuch()
    test_sumcol()
    test_startup()
    test_meteor()
.end

.sub 'lua' :anon
    .param string filename
    .param string params  :optional
    .param int has_params :opt_flag
    .local string cmd
    cmd = "parrot lua.pbc " . filename
    unless has_params goto L1
    cmd .= " "
    cmd .= params
  L1:
    $P0 = new 'FileHandle'
    $P0.'open'(cmd, 'rp')
    $P0.'encoding'('binary')
    $S0 = $P0.'readall'()
    $P0.'close'()
    .return ($S0)
.end

.sub 'slurp' :anon
    .param string filename
    $P0 = new 'FileHandle'
    push_eh _handler
    $P0.'encoding'('binary')
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
#   k-nucleotide
#       Hashtable update and k-nucleotide strings
#
.sub 'test_k_nucleotide'
    $S0 = lua('t/shootout/knucleotide_lua-2.lua', '< t/shootout/knucleotide-input.txt')
    $S1 = slurp('t/shootout/knucleotide-output.txt')
#    is($S0, $S1, "k-nucleotide")
    $I0 = $S0 == $S1
    todo($I0, "k-nucleotide")
.end

#
#   partial-sums
#       Naive iterative summation: power sin cos
#
.sub 'test_partialsums'
    $S0 = lua('t/shootout/partialsums_lua-3.lua', '25000')
    $S1 = slurp('t/shootout/partialsums-output.txt')
    is($S0, $S1, "partial-sums")
.end

#
#   fasta
#       Generate and write random DNA sequences
#
.sub 'test_fasta'
    $S0 = lua('t/shootout/fasta_lua-2.lua', '1000')
    $S1 = slurp('t/shootout/fasta-output.txt')
    is($S0, $S1, "fasta")
.end

#
#   pidigits
#       Streaming arbitrary-precision arithmetic
#
.sub 'test_pidigits'
    $S0 = lua('t/shootout/pidigits_lua-2.lua', '27')
    $S1 = slurp('t/shootout/pidigits-output.txt')
#    is($S0, $S1, "pidigits")
    $I0 = $S0 == $S1
    todo($I0, "pb with loadstring ?")
.end

#
#   nsieve
#       Indexed-access to boolean-sequence
#
.sub 'test_nsieve'
    $S0 = lua('t/shootout/nsieve_lua-3.lua')
    $S1 = slurp('t/shootout/nsieve-output.txt')
    is($S0, $S1, "nsieve")
.end

#
#   regex-dna
#       Match DNA 8-mers and substitute nucleotides for IUB codes
#
.sub 'test_regexdna'
    $S0 = lua('t/shootout/regexdna_lua-3.lua', '< t/shootout/regexdna-input.txt')
    $S1 = slurp('t/shootout/regexdna-output.txt')
#    is($S0, $S1, "regex-dna")
    $I0 = $S0 == $S1
    todo($I0, "pb with string.gsub ?")
.end

#
#   nsieve-bits
#       Indexed-access to bit-values
#
.sub 'test_nsievebits'
    $S0 = lua('t/shootout/nsievebits.lua')
    $S1 = slurp('t/shootout/nsievebits-output.txt')
    is($S0, $S1, "nsieve-bits")
.end

#
#   recursive
#       Naive recursive-algorithms: ack fib tak
#
.sub 'test_recursive'
    $S0 = lua('t/shootout/recursive.lua', '3')
    $S1 = slurp('t/shootout/recursive-output.txt')
    is($S0, $S1, "recursive")
.end

#
# mandelbrot
#       Generate Mandelbrot set portable bitmap file
#
.sub 'test_mandelbrot'
    $S0 = lua('t/shootout/mandelbrot_lua-2.lua', '200')
    $S1 = slurp('t/shootout/mandelbrot-output.txt')
    is($S0, $S1, "mandelbrot")
.end

#
#   n-body
#       Double-precision N-body simulation
#
.sub 'test_nbody'
    $S0 = lua('t/shootout/nbody_lua-2.lua', '1000')
    $S1 = slurp('t/shootout/nbody-output.txt')
    is($S0, $S1, "n-body")
.end

#
#   cheap-concurrency
#       Send messages between linked threads
#
.sub 'test_message'
    $S0 = lua('t/shootout/message_lua-2.lua', '10')
    $S1 = slurp('t/shootout/message-output.txt')
#    is($S0, $S1, "cheap-concurrency")
    $I0 = $S0 == $S1
    todo($I0, "maximum recursion depth exceeded")
.end

#
#   spectral-norm
#       Eigenvalue using the power method
#
.sub 'test_spectralnorm'
    $S0 = lua('t/shootout/spectralnorm_lua-3.lua', '100')
    $S1 = slurp('t/shootout/spectralnorm-output.txt')
    is($S0, $S1, "spectral-norm")
.end

#
#   chameneos
#       Symmetrical thread rendez-vous requests
#
.sub 'test_chameneos'
    $S0 = lua('t/shootout/chameneos.lua', '100')
    $S1 = slurp('t/shootout/chameneos-output.txt')
    is($S0, $S1, "chameneos")
.end

#
#   reverse-complement
#       Read DAN sequences - write their reverse-complement
#
.sub 'test_revcomp'
    $S0 = lua('t/shootout/revcomp_lua-3.lua', '< t/shootout/revcomp-input.txt')
    $S1 = slurp('t/shootout/revcomp-output.txt')
#    is($S0, $S1, "reverse-complement")
    $I0 = $S0 == $S1
    todo($I0, "reverse-complement")
.end

#
#   binary-trees
#       Allocate and deallocate many many binary trees
#
.sub 'test_binarytrees'
    $S0 = lua('t/shootout/binarytrees_lua-3.lua', '10')
    $S1 = slurp('t/shootout/binarytrees-output.txt')
    is($S0, $S1, "binary-trees")
.end

#
#   fannkuch
#       Indexed-access to tiny integer-sequence
#
.sub 'test_fannkuch'
    $S0 = lua('t/shootout/fannkuch_lua-3.lua', '7')
    $S1 = slurp('t/shootout/fannkuch-output.txt')
    is($S0, $S1, "fannkuch")
.end

#
#   sum-file
#       Read lines, parse and sum integers
#
.sub 'test_sumcol'
    $S0 = lua('t/shootout/sumcol.lua', '< t/shootout/sumcol-input.txt')
    $S1 = slurp('t/shootout/sumcol-output.txt')
    is($S0, $S1, "sum-file")
.end

#
#   startup
#       Measure 'hello world' program startup time
#
.sub 'test_startup'
    $S0 = lua('t/shootout/hello.lua')
    $S1 = slurp('t/shootout/hello-output.txt')
    is($S0, $S1, "startup")
.end

#
#   meteor-contest
#
#
.sub 'test_meteor'
    $S0 = lua('t/shootout/meteor_lua-4.lua')
    $S1 = slurp('t/shootout/meteor-output.txt')
#    is($S0, $S1, "meteor")
    $I0 = $S0 == $S1
    todo($I0, "pb with loadstring ?")
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
