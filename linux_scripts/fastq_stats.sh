#!/bin/bash

# Script to calculate GC content and basic sequence stats from a compressed FASTQ file

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input.fastq.gz>"
    exit 1
fi

input_file="$1"

echo "Processing file: $input_file"

# Extract and calculate stats
zcat "$input_file" | awk '{
    if (NR % 4 == 2) { 
        total_bases += length($0)
        gc_count += gsub(/[GCgc]/, "", $0)
        read_count++
    }
} 
END {
    gc_content = (gc_count / total_bases) * 100
    avg_read_length = total_bases / read_count
    print "Total Reads: " read_count
    print "Total Bases: " total_bases
    print "GC Content (%): " gc_content
    print "Average Read Length: " avg_read_length
}'
