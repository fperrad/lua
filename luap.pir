
=head1 NAME

parrot-luap - a compiler for Lua 5.1

=head1 SYNOPSIS

  $ parrot-luap script.lua
  $ parrot-luap --target=parse script.lua
                         PAST
                         POST
                         PIR

=head1 DESCRIPTION

parrot-luap is a compiler for Lua 5.1 on Parrot
with the standard interface of PCT::HLLCompiler.

=cut

.sub 'main' :anon :main
    .param pmc args
    load_language 'lua'
    $P0 = compreg 'lua'
    $S0 = "Compiler Lua 5.1 on Parrot  Copyright (C) 2005-2009, Parrot Foundation.\n"
    $P0.'commandline_banner'($S0)
    $P0.'command_line'(args, 'encoding'=>'utf8')
.end

=head1 AUTHOR

Francois Perrad

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2011, Parrot Foundation.

This program is free software; you may redistribute it and/or modify
it under the same terms as Parrot itself.

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
