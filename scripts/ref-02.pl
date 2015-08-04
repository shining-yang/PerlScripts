#!/usr/bin/perl -w
use strict;

my @input_numbers = (1, 2, 4, 8, 16, 32, 64);
my @indices_of_odd_digit_sums = grep {
	my $num = $input_numbers[$_];
	my $digit_sums = 0;
	$digit_sums += $_ for split //, $num;
	$digit_sums % 2;
	} 0 .. $#input_numbers;

print "Numbers with odd digit sums: @input_numbers[@indices_of_odd_digit_sums]\n";


