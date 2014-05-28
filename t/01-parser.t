use strict;
use warnings;
use Test::More;

use MARC::Parser::RAW;

my $failure =  eval {MARC::Parser::RAW->new()};
is( $failure, undef, 'croak missing argument');

my $parser = MARC::Parser::RAW->new('./t/camel.mrc');
isa_ok( $parser, 'MARC::Parser::RAW' );
my $record = $parser->next();
is_deeply(
    $record->[1],
    [ '001', undef, undef, '_', 'fol05731351 ' ],
    'first field'
);
is_deeply(
    $record->[6],
    [ '020', ' ', ' ', 'a', '0471383147 (paper/cd-rom : alk. paper)' ],
    'sixth field'
);
$record = $parser->next();
is_deeply(
    $record->[1],
    [ '001', undef, undef, '_', 'fol05754809 ' ],
    'first field'
);

$parser = MARC::Parser::RAW->new('./t/camel.mrc', 'UTF-8');
isa_ok( $parser, 'MARC::Parser::RAW' );
$record = $parser->next();
is_deeply(
    $record->[1],
    [ '001', undef, undef, '_', 'fol05731351 ' ],
    'first field'
);

done_testing;