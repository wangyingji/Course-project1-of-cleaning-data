# Getting and Cleaning Data Course Project

This repo contains the script and supporting files for the 
final project for the Coursera "Getting and Cleaning Data" course.

## Overview

The script and data set in this repo make use of the Human
Activity Recognition Using Smartphones Data Set from UCI.
Please see the accompanying [CodeBook.md](https://github.com/sweeber/ProgrammingAssignment4/blob/master/CodeBook.md)
for details on the data.

## Usage

1. Create a project directory and copy the run_analysis.R script into it.
1. Download and extract the UCI HAR dataset within this project directory. It should create a subdirectory named "UCI HAR Dataset" inside the project directory.
  * The dataset can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
1. Start R and be sure the working directory is set to the project directory.
1. Source run_analysis.R. It will create 2 files, both of which are descibed in detail in the code book:
  * A combined dataset of both test and train data with mean and standard deviation features: mean-std.combined.csv
  * A tidy dataset with the average of each feature for each subject and activity: mean-std-summary-tidy.txt

