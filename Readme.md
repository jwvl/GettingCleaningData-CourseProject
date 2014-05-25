# How to use run_analysis.R

The data needed for this script can be obtained here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Download the ZIP file and unzip it in the working directory. The script then does the following:

1. Merges the data from the ‘train’ and ‘test’ folders in the UCI dataset
2. Changes the activity IDs to descriptions, based on the lookup table found in activity_labels.txt
3. Makes a subset from this merged data set containing only columns that originally contained the strings “mean()” or “std()”
4. Transforms these data to a 180-row table where means are listed by subject and by activity for each of these retained columns.
5. Saves this transformed data set to a tab-separated file called tidyData.txt