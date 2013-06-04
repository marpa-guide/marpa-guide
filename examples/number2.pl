# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;
use Data::Dumper;

my $g = Marpa::R2::Scanless::G->new({
        default_action => '::first',
        source         => \(<<'END_OF_SOURCE'),

# include begin
:start        ::= numbers
numbers       ::= number+            action => ::array
number          ~ [\d]+
:discard        ~ ws
ws              ~ [\s]+
# include end

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });
my $input = "1 3 5 8 13 21 34 55";

print "Trying to parse:\n$input\n\n";
$re->read(\$input);
my $value = ${$re->value};
print "Output:\n".Dumper($value);
