#!/bin/bash

# Script to calculate GC content and basic sequence stats from a compressed FASTA or FASTQ file

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input.fasta.gz | input.fastq.gz>"
    exit 1
fi

input_file="$1"

echo "Processing file: $input_file"

# Process file and determine format
zcat "$input_file" | awk '
BEGIN { 
    format = "" 
}
{
    if (NR == 1) {
        if ($0 ~ /^>/) format = "FASTA"
        else if ($0 ~ /^@/) format = "FASTQ"
        else {
            print "Error: Unknown file format. Expected FASTA or FASTQ." > "/dev/stderr"
            exit 1
        }
    }
    if (format == "FASTA") {
        if ($0 !~ /^>/) {
            total_bases += length($0)
            gc_count += gsub(/[GCgc]/, "", $0)
            seq_count++
        }
    } else if (format == "FASTQ") {
        if (NR % 4 == 2) {  # Only process sequence lines
            total_bases += length($0)
            gc_count += gsub(/[GCgc]/, "", $0)
            seq_count++
        }
    }
} 
END {
    if (seq_count == 0 || total_bases == 0) {
        print "Error: No valid sequences found." > "/dev/stderr"
        exit 1
    }
    
    gc_content = (gc_count / total_bases) * 100
    avg_seq_length = total_bases / seq_count

    print "File Format: " format
    print "Total Sequences: " seq_count
    print "Total Bases: " total_bases
    print "GC Content (%): " gc_content
    print "Average Sequence Length: " avg_seq_length
}'
