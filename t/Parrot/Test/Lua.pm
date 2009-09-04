# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

package Parrot::Test::Lua;

require Parrot::Test;

=head1 Testing routines specific to 'lua'.

=head2 Description

Call 'Lua on Parrot' and 'original lua'.

=head2 Methods

=head3 new

Yet another constructor.

=cut

use strict;
use warnings;

use File::Spec;

sub new {
    return bless {};
}

sub get_test_prog {
    return $ENV{PARROT_LUA_TEST_PROG} || 'lua.pbc';
}

my %language_test_map = (
    output_is   => 'is_eq',
    output_like => 'like',
    output_isnt => 'isnt_eq',
);

foreach my $func ( keys %language_test_map ) {
    no strict 'refs';

    *{"Parrot::Test::Lua::$func"} = sub {
        my $self = shift;
        my ( $code, $output, $desc, %options ) = @_;

        my $count = $self->{builder}->current_test + 1;

        my $params = $options{params} || q{};

        my $lua_test = get_test_prog();
        my $parrot = File::Spec->catfile( $self->{relpath}, $self->{parrot} );
        # flatten filenames (don't use directories)
        my $lang_fn = File::Spec->rel2abs( Parrot::Test::per_test( '.lua', $count ) );
        my $pir_fn  = File::Spec->rel2abs( Parrot::Test::per_test( '.pir', $count ) );
        my $lua_out_fn = File::Spec->rel2abs(
            Parrot::Test::per_test( $lua_test eq 'lua' ? '.orig_out' : '.parrot_out', $count ) );
        my $test_prog_args = $ENV{TEST_PROG_ARGS} || q{};
        my @test_prog;
        my $src = (defined $code) ? $lang_fn : q{};
        if ( $lua_test eq 'lua' ) {
            @test_prog = (
                "lua $test_prog_args $src $params",
            );
        }
        elsif ( $lua_test eq 'luac.pl' ) {
            @test_prog = (
                "perl luac.pl $src",
                "$parrot $pir_fn $params",
            );
        }
        elsif ( $lua_test eq 'luap.pir' ) {
            @test_prog = (
                "$parrot luap.pir -o $pir_fn --target=pir $src",
                "$parrot $pir_fn $params",
            );
        }
        elsif ( $lua_test eq 'luac2pir.pir' ) {
            @test_prog = (
                "luac -o ${src}c $src",
                "$parrot luac2pir.pir ${src}c",
                "$parrot ${src}c.pir $params",
            );
        }
        elsif ( $lua_test eq 'lua.pbc' ) {
            @test_prog = (
                "$parrot lua.pbc $test_prog_args $src $params",
            );
        }
        else {
            die "unknown option : $lua_test\n";
        }

        # This does not create byte code, but lua code
        Parrot::Test::write_code_to_file( $code, $lang_fn )
            if (defined $code);

        # STDERR is written into same output file
        my $exit_code = Parrot::Test::run_command(
            \@test_prog,
            STDOUT => $lua_out_fn,
            STDERR => $lua_out_fn,
        );

        my $builder_func = $language_test_map{$func};

        # set a todo-item for Test::Builder to find
        my $call_pkg = $self->{builder}->exported_to() || q{};

        local *{ $call_pkg . '::TODO' } = ## no critic Variables::ProhibitConditionalDeclarations
                        \$options{todo} if defined $options{todo};

        # That's the reason for:   no strict 'refs';
        my $pass =
            $self->{builder}
            ->$builder_func( Parrot::Test::slurp_file($lua_out_fn), $output, $desc );
        unless ($pass) {
            my $diag = q{};
            my $test_prog = join ' && ', @test_prog;
            $diag .= "'$test_prog' failed with exit code $exit_code."
                if $exit_code;
            $self->{builder}->diag($diag) if $diag;
        }

        # The generated files are left in the t/* directories.
        # Let 'make clean' and 'svn:ignore' take care of them.

        return $pass;
        }
}

=head2 History

Mostly taken from F<languages/bc/lib/Parrot/Test/Bc.pm>.

=head2 See Also

F<languages/tcl/lib/Parrot/Test/Tcl.pm>

=cut

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

