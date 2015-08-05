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


my @x = (1, 4, 32, 12, 8, 10, 3, 108, 2);
my @y = (0, 8, 10, 3, 27, 9, 16, 209);

#### way 01
my @bigger_data;
my @bigger_indices = grep {
	$_ > $#y or $x[$_] > $y[$_];
} 0 .. $#x;
@bigger_data = @x[@bigger_indices];
print "Result: @bigger_data\n";

#### way 02
@bigger_data = map {
	if ($_ > $#y or $x[$_] > $y[$_]) {
		$x[$_];
	} else {
		();
	}
} 0 .. $#x;
print "Result: @bigger_data\n";

