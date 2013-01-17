# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;

# Try and change this number to something else
my $input = "199";

my $g = Marpa::R2::Scanless::G->new({
        action_object  => 'main',
        default_action => 'do_first_arg',
        source         => \(<<'END_OF_SOURCE'),

# include begin

:start  ::= number
number    ~ [\d]+

# include end

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });

print "Trying to parse:\n$input\n";
eval { $re->read(\$input) };
print $@ || 'ok';
print "\n";
