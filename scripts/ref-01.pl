#!/usr/bin/perl -w
use strict;

my %emp_tom = (
	name => 'Tom Cruize',
	age => 43,
	addr => '#307, Big-Hero Street'
);

print "Exists.\n" if exists $emp_tom{'addr'};


my $ref = \%emp_tom;

for my $k (keys %$ref) {
	print "Key: $k --> Value: $ref->{$k} \n";
}


###########################################################################
my %gilligan_info = (
	name	=> 'Gilligan',
	hat		=> 'White',
	shirt	=> 'Red',
	position => 'First Mate'
);

my $hash_ref = \%gilligan_info;
my $name1 = $gilligan_info{'name'};
my $name2 = ${$hash_ref}{'name'};
my $name3 = $hash_ref->{'name'};

print "$name1, $name2, $name3 \n";

my @keys = keys %$hash_ref;
print "@keys", "\n";

#####
my @href_array = (\%gilligan_info);

print "Name: ", ${$href_array[0]}{'name'}, "\n";

print "Name: ", $href_array[0]->{'name'}, "\n";
print "Name: ", $href_array[0]{'name'}, "\n";

#########

my %jack_info = (name => 'Jack', hat => 'Blue', shirt => 'Coffee', position => 'Captain');
push @href_array, \%jack_info;

my $fmt = "%-12s %-8s %-8s %-16s\n";
foreach my $person (@href_array) {
	printf $fmt,
		$person->{'name'},
		$person->{'hat'},
		$person->{'shirt'},
		$person->{'position'};
}

## Another way to print-out
for my $iter (@href_array) {
	printf $fmt, @$iter{qw(name hat shirt position)};
}
