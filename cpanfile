requires 'Readonly', '>= 1.0';

on test => sub {
    requires 'Perl::Tidy';
    requires 'Test::Code::TidyAll';
    requires 'Test::More', '0.96';
    requires 'Test::Perl::Critic';
};