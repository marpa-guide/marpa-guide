# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;
use Data::Dumper;

# Try and change this number to something else
my $input = "100 + 200";

my $g = Marpa::R2::Scanless::G->new({
        default_action => '::array',
        source         => \(<<'END_OF_SOURCE'),

:start    ::= language

# include begin

language  ::= (ws) number (ws) op_plus (ws) number (ws)

ws        ::= sp
ws        ::=

sp          ~ [ ]+

# include end

number      ~ [\d]+
op_plus     ~ '+'


END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });

print "Trying to parse:\n$input\n";
$re->read(\$input);
my $value = ${$re->value};

print "Output:\n";
print Dumper($value);

