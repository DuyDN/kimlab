#!/usr/bin/perl -w

use strict;

my $indir = 'Sr4Sn';
my $infile = 'Aligned.toTranscriptome.out.bam';
my $transcripts = '/opt/index/salmon/hs/genes.fa';
my $outdir = 'SrSn';
my $outfile = 'aligned.counts';

opendir(DIR,'.') or die "$!\n";
while(my $subdir = readdir(DIR)) {
    next unless -d $subdir;
    next if $subdir eq '.';
    next if $subdir eq '..';
    next if (-e "$subdir/$outdir/");
    my $read1 = $subdir . ".fastq";
    next unless (-e "$subdir/$read1");

    print "Analyzing $subdir\n";
    chdir($subdir);

    mkdir $outdir;
    system("salmon quant -t $transcripts -l U -a $indir/$infile -o $outdir/$outfile");

    chdir('..');
}
