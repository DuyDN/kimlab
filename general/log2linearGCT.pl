#!/usr/bin/perl -w

use strict;

die "Usage: log2linearGCT.pl <input_gct>\n" unless @ARGV == 1;

open(IN,$ARGV[0]) or die "Couldn't open $ARGV[0]: $!\n";

my $min = 99999;
my $max = -99999;

chomp($_ = <IN>); # skip header1
chomp($_ = <IN>); # skip header2
chomp($_ = <IN>); # skip header3

while(<IN>) {
    chomp;
    $_ =~ s/\r//;
    next if !$_;
    my @line = split(/\t/);
    for (my $c = 2; $c <= $#line; $c++) {
        next if $line[$c] eq '';
        if ($line[$c] > $max) {
            $max = $line[$c];
        }
        if ($line[$c] < $min) {
            $min = $line[$c];
        }
    }
}
#print "min: $min\nmax: $max\n";

seek IN,0,0;

chomp($_ = <IN>);
$_ =~ s/\r//;
print "$_\n"; # header1
chomp($_ = <IN>);
$_ =~ s/\r//;
print "$_\n"; # header2
chomp($_ = <IN>);
$_ =~ s/\r//;
print "$_\n"; # header3

$min = 0.001 if ($min > 0); # don't adjust if all values positive

while(<IN>) {
    chomp;
    $_ =~ s/\r//;
    next if !$_;
    my @line = split(/\t/);
    for (my $c = 2; $c <= $#line; $c++) {
        next if $line[$c] eq '';
        $line[$c] = 2**($line[$c] - $min + 0.001);
    }
    print join("\t",@line),"\n";
}
