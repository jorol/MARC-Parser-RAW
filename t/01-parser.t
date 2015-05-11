use strict;
use warnings;
use Test::More;

use MARC::Parser::RAW;

new_ok( 'MARC::Parser::RAW' => ['./t/camel.mrc'] );
new_ok( 'MARC::Parser::RAW' => ['./t/camel.mrc', 'UTF-8'] );
can_ok( 'MARC::Parser::RAW', qw{ next });
my $failure =  eval { MARC::Parser::RAW->new() };
is( $failure, undef, 'croak missing argument' );
$failure = eval { MARC::Parser::RAW->new('./t/camel.mrk') };
is( $failure, undef, 'croak cannot find file');
$failure = eval { MARC::Parser::RAW->new('./t/camel.mrc', 'XXX-0') };
is( $failure, undef, 'croak unavailable encoding');

my $parser = MARC::Parser::RAW->new('./t/camel.mrc');
my $record = $parser->next();
is_deeply(
    $record->[0],
    [ 'LDR', undef, undef, '_', '00755cam  22002414a 4500' ],
    'LDR'
);
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

{
    my @warnings;
    local $SIG{__WARN__} = sub {
         push @warnings, @_;
    };
    my $record = $parser->next();
    is_deeply(
        $record->[0],
        [ 'LDR', undef, undef, '_', '00665nam  22002298a 4500' ],
        'skipped faulty records'
    );
    is scalar(@warnings), 4, 'got warnings';
    like $warnings[0], qr{no fields found in record}, 'carp no fields found in record';
    like $warnings[1], qr{no valid record leader found in record}, 'carp no valid record leader found in record';
    like $warnings[2], qr{different number of tags and fields in record}, 'carp different number of tags and fields in record';
    like $warnings[3], qr{incomplete directory entry in record}, 'carp incomplete directory entry in record';
}

done_testing;