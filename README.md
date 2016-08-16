# NAME

MARC::Parser::RAW - Parser for ISO 2709 encoded MARC records

[![Build Status](https://travis-ci.org/jorol/MARC-Parser-RAW.png)](https://travis-ci.org/jorol/MARC-Parser-RAW)
[![Coverage Status](https://coveralls.io/repos/jorol/MARC-Parser-RAW/badge.png?branch=devel)](https://coveralls.io/r/jorol/MARC-Parser-RAW?branch=devel)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/MARC-Parser-RAW.png)](http://cpants.cpanauthors.org/dist/MARC-Parser-RAW)

# SYNOPSIS

    use MARC::Parser::RAW;

    my $parser = MARC::Parser::RAW->new( $file );

    while ( my $record = $parser->next() ) {
        # do something        
    }

# DESCRIPTION

[MARC::Parser::RAW](https://metacpan.org/pod/MARC::Parser::RAW) is a lightweight, fault tolerant parser for ISO 2709 
encoded MARC records. Tags, indicators and subfield codes are not validated 
against the MARC standard. Record length from leader and field lengths from 
the directory are ignored. Records with a faulty structure will be skipped 
with a warning. The resulting data structure is optimized for usage with the 
[Catmandu](https://metacpan.org/pod/Catmandu) data tool kit.    

[MARC::Parser::RAW](https://metacpan.org/pod/MARC::Parser::RAW) expects UTF-8 encoded files as input. Otherwise provide 
a filehande with a specified I/O layer or specify encoding.

# MARC

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

# METHODS

## new($file|$fh \[, $encoding\])

### Configuration

- `file`

    Path to file with raw MARC records.

- `fh`

    Open filehandle for raw MARC records.

- `encoding`

    Set encoding. Default: UTF-8. Optional.

## next()

Reads the next record from MARC input stream. Returns a Perl hash.

## \_decode($record)

Deserialize a raw MARC record to an ARRAY of ARRAYs.

## \_field($field)

Split MARC field string in individual components.

# AUTHOR

Johann Rolschewski &lt;jorol@cpan.org>

# COPYRIGHT

Copyright 2014- Johann Rolschewski

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEEALSO

[Catmandu](https://metacpan.org/pod/Catmandu), [Catmandu::Importer::MARC](https://metacpan.org/pod/Catmandu::Importer::MARC).

# ACKNOWLEDGEMENT

The parser methods are adapted from Marc Chantreux's [MARC::MIR](https://metacpan.org/pod/MARC::MIR) module.
