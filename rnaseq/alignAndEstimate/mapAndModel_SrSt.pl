#!/usr/bin/perl -w

use strict;

my $genesgtf = '/opt/index/hs/genes.gtf';
my $indir = 'Sr4St';
my $infile = 'Aligned.out.sam';
my $outdir = 'SrSt';
my $outfile = 'expression.gtf';
my $tableOut = 'expression.tab';
my $cpu = 4;

opendir(DIR,'.') or die "$!\n";
while(my $subdir = readdir(DIR)) {
    next unless -d $subdir;
    next if $subdir eq '.';
    next if $subdir eq '..';
    next if (-e "$subdir/$outdir/");

    print "Analyzing $subdir\n";
    chdir($subdir);

    mkdir $outdir;
    system("samtools sort -o $outdir/$infile\.sorted $indir/$infile");
    system("stringtie $outdir/$infile\.sorted -p $cpu -o $outdir/$outfile -G $genesgtf -A $outdir/$tableOut -B -e");

    chdir('..');
}

system("notify2.pl $outdir\_MappingComplete\n");
