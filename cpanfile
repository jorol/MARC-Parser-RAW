requires 'perl', '5.012005';

requires 'Readonly', '>= 1.0';
requires 'Encode', '>= 2.5';

on test => sub {
    requires 'Test::More', '0.96';
};