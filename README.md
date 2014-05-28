MARC-Parser-RAW - Parser for raw MARC data. Optimized for [Catmandu](https://metacpan.org/module/Catmandu).

# Installation

Install the latest distribution from CPAN:

    cpanm MARC-Parser-RAW

Install the latest developer version from GitHub:

    cpanm git@github.com:jorol/MARC-Parser-RAW.git@devel

# Contribution

For bug reports and feature requests use <https://github.com/jorol/MARC-Parser-RAW/issues>.

For contributions to the source code create a fork or use the `devel` branch. The master
branch should only contain merged and stashed changes to appear in Changelog.

Dist::Zilla and build requirements can be installed this way:

    cpan Dist::Zilla
    dzil authordeps | cpanm

Build and test your current state this way:

    dzil build
    dzil test 
    dzil smoke --release --author # test more

# Status

Build and test coverage of the `devel` branch at <https://github.com/jorol/MARC-Parser-RAW/>:

[![Build Status](https://travis-ci.org/jorol/MARC-Parser-RAW.png)](https://travis-ci.org/jorol/MARC-Parser-RAW)
[![Coverage Status](https://coveralls.io/repos/jorol/MARC-Parser-RAW/badge.png?branch=devel)](https://coveralls.io/r/jorol/MARC-Parser-RAW?branch=devel)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/MARC-Parser-RAW.png)](http://cpants.cpanauthors.org/dist/MARC-Parser-RAW)
