package MARC::Parser::RAW;

# ABSTRACT: MARC RAW format parser
# VERSION

use strict;
use warnings;
use charnames qw< :full >;
use Carp qw(croak carp);
use Encode qw(find_encoding);
use Readonly;

Readonly my $LEADER_LEN         => 24;
Readonly my $SUBFIELD_INDICATOR => qq{\N{INFORMATION SEPARATOR ONE}};
Readonly my $END_OF_FIELD       => qq{\N{INFORMATION SEPARATOR TWO}};
Readonly my $END_OF_RECORD      => qq{\N{INFORMATION SEPARATOR THREE}};

=head1 SYNOPSIS

    use MARC::Parser::RAW;

    my $parser = MARC::Parser::RAW->new( $file );

    while ( my $record = $parser->next() ) {
        # do something        
    }

=head1 DESCRIPTION

L<MARC::Parser::RAW> is a lightweight, fault tolerent parser for raw MARC 
records. Tags, indicators and subfield codes are not validated against the 
MARC standard. Record length from leader and field lengths from the directory 
are ignored. Records with a faulty structure will be skipped with a warning. 
The resulting data structure is optimized for usage with the L<Catmandu> data 
tool kit.    

L<MARC::Parser::RAW> expects UTF-8 encoded files as input. Otherwise provide a 
filehande with a specified I/O layer or specify encoding.

=head1 MARC

The MARC record is parsed into an ARRAY of ARRAYs:

    $record = [
            [ 'LDR', undef, undef, '_', '00661nam  22002538a 4500' ],
            [ '001', undef, undef, '_', 'fol05865967 ' ],
            ...
            [   '245', '1', '0', 'a', 'Programming Perl /',
                'c', 'Larry Wall, Tom Christiansen & Jon Orwant.'
            ],
            ...
        ];


=head1 METHODS

=head2 new($file|$fh [, $encoding])

=head1 Configuration

=over

=item C<file>
 
Path to file with raw MARC records.

=item C<fh>

Open filehandle for raw MARC records.

=item C<fh>

Set encoding. Default: UTF-8. Optional.

=back

=cut

sub new {
    my ( $class, $file, $encoding ) = @_;

    $file or croak "first argument must be a file or filehandle";

    if ($encoding) {
        find_encoding($encoding)
            or croak "encoding \"$_[0]\" is not a valid encoding";
    }

    my $self = {
        file       => undef,
        fh         => undef,
        encoding   => $encoding ? $encoding : 'UTF-8',
        rec_number => 0,
    };

    # check for file or filehandle
    my $ishandle = eval { fileno($file); };
    if ( !$@ && defined $ishandle ) {
        $self->{file} = scalar $file;
        $self->{fh}   = $file;
    }
    elsif ( -e $file ) {
        open $self->{fh}, "<:encoding($self->{encoding})", $file
            or croak "cannot read from file $file\n";
        $self->{file} = $file;
    }
    else {
        croak "file or filehande $file does not exists";
    }
    return ( bless $self, $class );
}

=head2 next()

Reads the next record from MARC input stream. Returns a Perl hash.

=cut

sub next {
    my $self = shift;
    my $fh   = $self->{fh};
    local $/ = $END_OF_RECORD;
    if ( my $record = <$fh> ) {
        $self->{rec_number}++;

        # remove illegal garbage that sometimes occurs between records
        $record
            =~ s/^[\N{SPACE}\N{NUL}\N{LINE FEED}\N{CARRIAGE RETURN}\N{SUB}]+//;
        return unless $record;

        my $record = _decode($record);
        if ( scalar @{$record} > 1 ) {
            return $record;
        }
        carp $record->[0] . $self->{rec_number};
        $self->next();
    }
    else {
        return;
    }
}

=head2 _decode($record)

Deserialize a raw MARC record to an ARRAY of ARRAYs.

=cut

sub _decode {
    my $raw = shift;
    chop $raw;
    my ( $head, @fields ) = split $END_OF_FIELD, $raw;

    if ( !@fields ) {
        return ["no fields found in record "];
    }

    # ToDO: better RegEX for leader
    if ( $head !~ /(.{$LEADER_LEN})/cg ) {
        return ["no record leader found in record "];
    }

    my $leader = $1;
    my @tags   = $head =~ /\G(\d{3})\d{9}/cg;

    if ( scalar @tags != scalar @fields ) {
        return ["different number of tags and fields in record "];
    }

    if ( $head !~ /\G$/cg ) {
        my $tail = $1 if $head =~ /(.*)/cg;
        return ["incomplete directory entry in record "];
    }

    return [
        [ 'LDR', undef, undef, '_', $leader ],
        map [ shift(@tags), _field($_) ],
        @fields
    ];
}

=head2 _field($field)

Split MARC field string in individual components.

=cut

sub _field {
    my ($field) = @_;
    my @chunks = split( /$SUBFIELD_INDICATOR(.)/, $field );
    return ( undef, undef, '_', @chunks ) if @chunks == 1;
    my @subfields;
    my ( $indicator1, $indicator2 ) = ( split //, shift @chunks );
    while (@chunks) {
        push @subfields, ( splice @chunks, 0, 2 );
    }
    return ( $indicator1, $indicator2, @subfields );
}

=head1 SEEALSO

L<Catmandu>, L<Catmandu::Importer::MARC>.

=head1 Acknowledgement

The parser methods are adapted from Marc Chantreux's L<MARC::MIR> module.

=cut

1;    # End of MARC::Parser::RAW

