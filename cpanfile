requires 'DateTime';
requires 'DateTime::Calendar::Chinese';
requires 'DateTime::Calendar::Japanese::Era';
requires 'DateTime::Event::Sunrise';
requires 'DateTime::Util::Calc';
requires 'Params::Validate';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
};
