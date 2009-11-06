#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

.include 'sysinfo.pasm'
.include 'iglobals.pasm'

.sub 'main' :main
    load_bytecode 'Configure.pbc'

    # Wave to the friendly users
    print "Hello, I'm Configure. My job is to poke and prod\n"
    print "your system to figure out how to build Lua.\n"

    .local pmc config
    $P0 = getinterp
    config = $P0[.IGLOBALS_CONFIG_HASH]
    .local string OS
    OS = sysinfo .SYSINFO_PARROT_OS

    # Here, do the job
    push_eh _handler
    genfile('config/makefiles/root.in', 'Makefile', config)
    genfile('config/makefiles/pmc.in', 'src/pmc/Makefile', config)
        pop_eh

    # Give the user a hint of next action
    .local string make
    make = config['make']
    print "Configure completed for platform '"
    print OS
    print "'.\n"
    print "You can now type '"
    print make
    print "' to build Lua.\n"
    print "You may also type '"
    print make
    print " test' to run the Lua test suite.\n"
    print "\nHappy Hacking.\n"
    end

  _handler:
    .local pmc e
    .local string msg
    .get_results (e)
    printerr "\n"
    msg = e
    printerr msg
    printerr "\n"
    end
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

