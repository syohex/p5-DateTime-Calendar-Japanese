# NAME

DateTime::Calendar::Japanese - DateTime Extension for Traditional Japanese Calendars

# SYNOPSIS

    use DateTime::Calendar::Japanese;

    # Construct a DT::C::Japanese object using the Chinese hexagecimal
    # cycle system
    my $dt = DateTime::Calendar::Japanese->new(
      cycle        => $cycle,
      cycle_year   => $cycle_year,
      month        => $month,
      leap_month   => $leap_month,
      day          => $day,
      hour         => $hour,
      hour_quarter => $hour_quarter
    );

    # Construct a DT::C::Japanese object using the era system
    use DateTime::Calendar::Japanese::Era qw(HEISEI);
    my $dt = DateTime::Calendar::Japanese->new(
      era_name     => HEISEI,
      era_year     => $era_year,
      month        => $month,
      leap_month   => $leap_month,
      day          => $day,
      hour         => $hour,
      hour_quarter => $hour_quarter
    );

    $cycle          = $dt->cycle;
    $cycle_year     = $dt->cycle_year;
    $era            = $dt->era;   # era object
    $era_name       = $dt->era_name;
    $era_year       = $dt->era_year;
    $month          = $dt->month;
    $leap_month     = $dt->leap_month;
    $day            = $dt->day;
    $hour           = $dt->hour;
    $canonical_hour = $dt->canonical_hour
    $hour_quarter   = $dt->hour_quarter;

# DESCRIPTION

This module implements the traditional Japanese Calendar, which was used
from circa 692 A.D. to 1867 A.D. The traditional Japanese Calendar is a
_lunisolar calendar_ based on the Chinese Calendar, and therefore
this module may \*not\* be used for handling or formatting modern Japanese
calendars which are Gregorian Calendars with a twist.
Please use DateTime::Format::Japanese for that purpose.

On top of the lunisolar calendar, this module implements a simple time
system used in the Edo period, which is a type of temporal hour system, 
based on sunrise and sunset.

# CAVEATS/DISCLAIMERS

## SPEED

This module is based on [DateTime::Calendar::Chinese](https://metacpan.org/pod/DateTime::Calendar::Chinese), which in turn is
based on positions of the Moon and the Sun. Calculations of this sort is
definitely not Perl's forte, and therefore this module is \*very\* slow.

Help is much appreciated to rectify this :)

## CALENDAR "VERSION"

Note that for each of these calendars there exist numerous different
versions/revisions. The Japanese Calendar has at least 6 different
revisions.

The Japanese Calendar that is implemented here uses the algorithm described
in the book "Calendrical Computations" \[1\], which presumably describes the
latest incarnation of these calendars.

## ERA DISCREPANCIES FROM MODERN JAPANESE DATES

Even though this module can handle modern dates, note that this module
creates dates in the \*traditional\* calendar, NOT the modern gregorian
calendar used in Japane since the Meiji era. Yet, we must honor the gregorian
date in which an era started or ended. This means that the era year
calculations could be off from what you'd expect on a modern calendar.

For example, the Heisei era starts on 08 Jan 1989 (Gregorian), so in a 
modern calendar you would expect the rest of year 1989 to be Heisei 1.
However, the Chinese New Year happens to fall on 06 Feb 1989. Thus
this module would see that and increment the era year by one on that
date.

If you want to express modern Japanese calendars, you will need to use
[DateTime::Format::Japanese](https://metacpan.org/pod/DateTime::Format::Japanese) module on the vanilla DateTime object. 
(As of this writing DateTime::Format::Japanese is in alpha release. Use
at your own peril)

## TIME COMPONENTS

The time component is based on the little that I already knew about the
traditional Japanese time system and numerous resources available on the net.

As for the Japanese time system, not much detail was available to me.
I searched in various resources on the net and used a combined alogorithm
(see ["REFERENCES"](#references)) to produce what seemed logical (and simple enough for
me) to emulate the time system implemented in this module is from the one
used during the Edo period (1600's - 1800's). 

If there are any corrections, please let me know.

Also note that this module Currently assumes that the sunrise/sunset hours
are calculated based on Tokyo latitude/longitude.

# THE TRADITIONAL JAPANESE (EDO) TIME SYSTEM

The time system that is implemented in this module is the time system used
in the Edo era, during the time of the Tokugawa shogunate (1603 - 1867).

This time system is completely unlike the ones we are used in the modern
world, mainly in that the notion of an "hour" changes from season to
season.  The days were divided in to two parts, from sunrise to sunset, and
from sunset to sunrise. Each of these parts were then divided into 6 equal
parts.

This also means that an "hour" has a different length depending on the
season, and it even differs between day and night. However, for those people
with no watches or clocks, it's sometimes more convenient because the
position of the sun directly corelates to the time of the day.

Even more complicated to us is the fact that Japanese hours have a slightly
complex numbering scheume. The hours do not start from 1. Instead, the hour
that starts with the sunrise is hour "6", then "5", "4", and then "9", all
the way back to "6". Each of these hours also have a corresponding name,
which is based on the Chinese Zodiac.

    ------------------
    | Hour | Zodiac  |
    ------------------
    |   6  | Hare    | <-- Sunrise ---
    ------------------               |
    |   5  | Dragon  |               |
    ------------------               |
    |   4  | Snake   |               |
    ------------------               |---- Day
    |   9  | Horse   |               |
    ------------------               |
    |   8  | Sheep   |               |
    ------------------               |
    |   7  | Monkey  |----------------
    ------------------
    |   6  | Fowl    | <-- Sunset ----
    ------------------               |
    |   5  | Dog     |               |
    ------------------               | 
    |   4  | Pig     |               | 
    ------------------               |---- Night
    |   9  | Rat     |               | 
    ------------------               | 
    |   8  | Ox      |               | 
    ------------------               | 
    |   7  | Tiger   |----------------
    ------------------

These names are used standalone or sometimes interchangeably. For example,
"ne no koku" literary means "the hour of hare", but you can also say
"ake mutsu" which means "morning 6".

For computational purposes, DateTime::Calendar::Japanese will number the
hours 1 to 12. (You can get the canonical representation by using the
canonical\_hour() method)

Each hour is further broken up in 4 parts, which is combined with the
hour notation to express a more precise time, for example:

    hour of Ox, 3rd quarter (around 3 a.m.)

# METHODS

## new

There are two forms to the constructor. One form accepts "era" and "era\_year"
to define the year, and the other accepts "cycle" and "cycle\_year". The
rest of the parameters are the same, and they are: "month", "leap\_month",
"day", "hour", "hour\_quarter".

    use DateTime::Calendar::Japanese;
    use DateTime::Calendar::Japanese::Era qw(TAIKA);
    my $dt = DateTime::Calendar::Japanese->new(
      era          => TAIKA,
      era_year     => 1,
      month        => 7,
      day          => 25,
      hour         => 4,
      hour_quarter => 3
    );

    # DateTime::Calendar::Chinese style
    my $dt = DateTime::Calendar::Japanese->new(
      cycle        => 78,
      cycle_year   => 20,
      month        => 3,
      day          => 4,
      hour         => 4,
      hour_quarter => 3
    );

See the documentation for DateTime::Calendar::Chinese for the semantics
of cycle and cycle\_year

## now

## from\_epoch

## from\_object

These constructors are exactly the same as those in DateTime::Calendar::Chinese

## set

Sets DateTime components.

## utc\_rd\_values

Returns the current UTC Rata Die days, seconds, and nanoseconds as a three
element list. This exists primarily to allow other calendar modules to create
objects based on the values provided by this object.

## cycle

Returns the current cycle. See [DateTime::Calendar::Chinese](https://metacpan.org/pod/DateTime::Calendar::Chinese)

## cycle\_year

Returns the current cycle\_year. See [DateTime::Calendar::Chinese](https://metacpan.org/pod/DateTime::Calendar::Chinese)

## era

Returns the DateTime::Calendar::Japanese::Era object associated with this
calendar.

## era\_name

Returns the name (id) of the DateTime::Calendar::Japanese::Era object
associated with this calendar.

## era\_year

Returns the number of years in the current era, as calculated by the
traditional lunisolar calendar. Note that calculations will be different
from those based on the modern calendar, as the date of New Year (which is
when era years are incremented) differ from modern calendars. For example,
based on the traditional calendar, SHOUWA3 (1926 - 1989) had only 63 years,
not 64. See [CAVEATS](#era-discrepancies-from-modern-japanese-dates)

## hour

Returns the hour, based on the traditional Japanese time system. The
hours are encoded from 1 to 12 to uniquely qulaify them. However, you
can get the canonical hour by using the canonical\_hour() method

1 is the time of sunrise, somewhere around 5am to 6am, depending on the
time of the year (This means that hour 12 on a given date is actually BEFORE
hour 1)

## canonical\_hour

Returns the canonical hour, based on the numbering system described
in [the above section](#the-traditional-japanese-edo-time-system),
which counts from 9 to 4, and back to 9.

## hour\_quarter

Returns the quarter in the current hour (1 to 4).

# AUTHOR

Copyright (c) 2004-2007 Daisuke Maki &lt;daisuke@endeworks.jp&lt;gt>

# LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

# REFERENCES

    [1] Edward M. Reingold, Nachum Dershowitz
        "Calendrical Calculations (Millenium Edition)", 2nd ed.
         Cambridge University Press, Cambridge, UK 2002

    [2] http://homepage2.nifty.com/o-tajima/rekidaso/calendar.htm
    [3] http://www.tanomi.com/shop/items/wa_watch/index2.html
    [4] http://www.geocities.co.jp/Playtown/6757/edojikan01.html
    [5] http://www.valley.ne.jp/~ariakehs/Wadokei/hours_system.html

# SEE ALSO

[DateTime](https://metacpan.org/pod/DateTime)
[DateTime::Set](https://metacpan.org/pod/DateTime::Set)
[DateTime::Span](https://metacpan.org/pod/DateTime::Span)
[DateTime::Calendar::Chinese](https://metacpan.org/pod/DateTime::Calendar::Chinese)
[DateTime::Calendar::Japanese::Era](https://metacpan.org/pod/DateTime::Calendar::Japanese::Era)
[DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise)
