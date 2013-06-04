# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;
use Data::Dumper;

my $g = Marpa::R2::Scanless::G->new({
        default_action => '::array',
        source         => \(<<'END_OF_SOURCE'),

# include begin
:start        ::= rules
rules         ::= rule+

rule          ::= cmd_type username

cmd_type        ~ 'Deny' | 'Allow'
username        ~ [\w]+

:discard        ~ ws
ws              ~ [\s]+
# include end

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });
my $input = <<"INPUT";
Deny baduser
Allow admin
INPUT

print "Trying to parse:\n$input\n\n";
$re->read(\$input);
my $value = ${$re->value};
print "Output:\n".Dumper($value);
