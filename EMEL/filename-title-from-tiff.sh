#!/usr/local/bin/bash

# Extract the source file path to column A and title metadata to column B
echo Path to MS directory:
read pathToMSDirectory
echo Output filename without extension or spaces:
read pathToCSV
exiftool -csv -Title $pathToMSDirectory > $pathToCSV"_temp.csv"

# Sort rows of CSV and save the output to a new/final CSV
sort -k1 -n -t, $pathToCSV"_temp.csv" > $pathToCSV".csv"

# Delete the first CSV
rm $pathToCSV"_temp.csv"

# Remove the first 4 rows (the sample shots) from the CSV
sed -i '' 1,4d $pathToCSV".csv"

# Remove the last row (the header row, now last after sort)
sed -i '' '$d' $pathToCSV".csv"

# Truncate the file path with only filenames left in column A
sed -i '' 's:^\/.*sld:sld:' $pathToCSV".csv"

# Remove "MS name" (not the directory name) as recorded in TIFF header, e.g. Sinai Arabic 14, from title in column B and prepend the titles' page counter with "f." standing for "folio"
echo MS name, as recorded in TIFF header, to be removed:
read MSname
sed -i "" "/^[^,]*_f_[^,_]*,/s/,$MSname /,f. /
    s/,$MSname /,/" $pathToCSV".csv"
