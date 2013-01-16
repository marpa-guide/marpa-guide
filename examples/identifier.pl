# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;

my $g = Marpa::R2::Scanless::G->new({
        action_object  => 'main',
        default_action => 'do_first_arg',
        source         => \(<<'END_OF_SOURCE'),

:start        ::= identifier

# include begin

identifier      ~ [_a-zA-Z] id_rest
id_rest         ~ [_0-9a-zA-Z]*

# include end

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });
my $input = "_hello";

print "Trying to parse:\n$input\n";
eval { $re->read(\$input) };
print $@ || 'ok';
print "\n";

