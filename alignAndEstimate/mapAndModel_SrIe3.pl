#!/usr/bin/perl -w

use strict;

my $genes = '/opt/index/isoem/hs/genes_reduced.gtf';
my $indir = 'Sr';
my $infile = 'Aligned.out.sam';
my $outdir = 'SrIe';


opendir(DIR,'.') or die "$!\n";
while(my $subdir = readdir(DIR)) {
    next unless -d $subdir;
    next if $subdir eq '.';
    next if $subdir eq '..';
    next if (-e "$subdir/$outdir/");
    my $read1 = $subdir . ".fastq";
    next unless (-e "$subdir/$read1");

    print "\n\nAnalyzing $subdir\n";
    chdir($subdir);

    mkdir $outdir;
    system("time ../isoem2_modifiedTest_setMaxMem100G -G $genes -m 360 -d 200 -O $outdir $indir/$infile");
 
    chdir('..');
}

system("notify2.pl $outdir\_MappingComplete\n");
