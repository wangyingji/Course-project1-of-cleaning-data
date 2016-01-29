# Creates a tidy, summarized data set from the Human Activity data set
# performing the following steps:
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation
#   for each measurement.
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names.
# - From the data set in the previous step, creates a second, independent
#   tidy data set with the average of each variable for each activity and
#   each subject.


library(data.table)
library(dplyr)
library(tidyr)

# Read a set of UCI files (either test or train) and construct a
# consolidated data table of just the mean and std values.
readUCI <- function(subdir, features) {
  # Construct filenames
  XFile       <- paste0('UCI HAR Dataset/', subdir, '/X_', subdir, '.txt')
  subjectFile <- paste0('UCI HAR Dataset/', subdir, '/subject_', subdir, '.txt')
  yFile       <- paste0('UCI HAR Dataset/', subdir, '/y_', subdir, '.txt')
  
  # Load the result data
  resDT <- fread(XFile, col.names = features)
  
  # Load the subject data
  subjectDT <- fread(subjectFile, 
                     col.names = c("Subject"), 
                     colClasses = list(factor=1), 
                     stringsAsFactors = TRUE)
  
  # Load the activity data
  actDT <- fread(yFile, 
                 col.names = c("Activity"), 
                 colClasses = list(factor=1), 
                 stringsAsFactors = TRUE)
  
  # Create a new data table which is the combination of:
  # - Subject
  # - Activity
  # - All mean and standard deviation values for each observation
  
  combinedDT <- cbind(subjectDT,
                      actDT,
                      select(resDT, matches("\\.std|\\.mean\\.|\\.mean$")))
  return(combinedDT)
}



# Read the data set from the componenent files and create a data table with
# the result.

# First load the "features.txt" file, which describes the variable names
# for each column.
featuresFile <- 'UCI HAR Dataset/features.txt'
featuresDT <- fread(featuresFile)

# Clean up the variable names
# Change '-' to '.', and remove ( and )
featuresDT$V2 <- gsub('-','.',featuresDT$V2)
featuresDT$V2 <- gsub('\\(','',featuresDT$V2)
featuresDT$V2 <- gsub('\\)','',featuresDT$V2)

# Load the Activity Labels
activityLabelsDT <- fread('UCI HAR Dataset/activity_labels.txt')

# Read the data from the raw data files
testCombinedDT = readUCI('test',featuresDT$V2)
trainCombinedDT = readUCI('train',featuresDT$V2)

# Create a combined data table with both "test" and "train" data
allDT <- rbind(testCombinedDT, trainCombinedDT)

# Change the factor labels for the activities
# Use a for loop in case the indexes and values aren't always
# sequential.
for (i in 1:dim(activityLabelsDT)[1]){
  levels(allDT$Activity)[activityLabelsDT$V1[i]] <- activityLabelsDT$V2[i]
}

# Write this data set out
write.csv(allDT, file = "mean-std-combined.csv", row.names = FALSE)

# Gather the mean and std results
gatheredDT <- gather(allDT,
                     Feature, Value, -(Subject:Activity))

summaryDT <- summarize(group_by(gatheredDT, Subject, Activity, Feature), mean=mean(Value))

# Spread the summary data back into a wide data frame
tidyDT <- spread(summaryDT, Feature, mean)

# Write this data set out
write.table(tidyDT, file = "mean-std-summary-tidy.txt", row.names = FALSE)