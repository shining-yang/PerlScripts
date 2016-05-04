#!/usr/bin/perl -w
#
# List contents of directory in tree-like format.
#
# y.s.n@live.com, 2016-05-04
#
use strict;

my $dir = "."; # default to current directory
my $show_hidden = 0;
my $append_indicator = 0;
my @last_items = (); # indicate whether item (file/directory) is the last one
my ($dir_counter, $file_counter) = (0, 0);

for (@ARGV) {
    if (!/^-/) {
        $dir = $_;
    } else {
        if (/^-a$/) { # show all items
            $show_hidden = 1;
        } elsif (/^-F$/) { # append indicator
            $append_indicator = 1;
        } elsif (/^--help$/) {
            print_usage();
            exit 0;
        } else {
            print_usage();
            exit 0;
        }
    }
}

sub print_usage {
    my $script_name = __FILE__;
    my @usage = (
        "Usage: $script_name [options] [directory]\n",
        "  options:\n",
        "  -a           list all files, including hidden items\n",
        "  -F           append indicator to entries\n",
        "  --help       print this message\n",
        "\n"
    );
    
    print @usage;
}
    
sub print_item {
    my ($item, $depth) = @_;
    for (my $i = 0; $i < ($depth - 1) * 4; $i++) {
        if (($i % 4 == 0) && ($last_items[$i / 4] == 0)) {
            print '│';
        } else {
            print ' ';
        }
    }

    if ($last_items[$depth - 1]) {
        print "└── ", $item, "\n";
    } else {
        print "├── ", $item, "\n";
    }
}

sub print_directory {
    my ($directory, $depth) = @_;
    my @items;

    opendir(my $dir_handle, $directory) ||
        return print "Cannot open directory: $directory, $!\n";

    if ($show_hidden) {
        @items = grep { !/^\.{1,2}$/ } readdir($dir_handle);
    } else {
        @items = grep { !/^\./ } readdir($dir_handle);
    }

    closedir $dir_handle;

    @items = sort {
        my ($ca, $cb) = ($a, $b);
        $ca =~ s/[\._-]//g;
        $cb =~ s/[\._-]//g;
        lc($ca) cmp lc($cb);
    } @items;

    $last_items[$depth] = 0;

    for (my $i = 0; $i < @items; $i++) {
        if ($i == $#items) {
            $last_items[$depth] = 1;
        }

        my $full_path = $directory . "/" . $items[$i];   
        
        my $is_dir = 0;
        $is_dir = 1 if (-d $full_path);

        my $is_link = 0;
        $is_link = 1 if (-l $full_path);
        
        my $postfix = "";
        $postfix .= " -> " . readlink($full_path) if ($is_link);

        if ($append_indicator) {
            my ($is_exec, $is_fifo, $is_socket);
            $is_exec = 1    if (-x $full_path);
            $is_fifo = 1    if (-p _);
            $is_socket = 1  if (-S _);
            
            if ($is_dir) {
                $postfix .= "/";
            } else {
                if ($is_exec) {
                    $postfix .= "*";
                } elsif ($is_fifo) {
                    $postfix .= "|";
                } elsif ($is_socket) {
                    $postfix .= "=";
                }
            }
        }

        print_item($items[$i] . $postfix, $depth + 1);

        if ($is_dir) {
            $dir_counter++;
            if (!$is_link) {
                print_directory($full_path, $depth + 1);
            }
        } else {
            $file_counter++;
        }
    }
}

print $dir, "\n";
print_directory($dir, 0);
print "\n", $dir_counter, " directories, ", $file_counter, " files\n";

