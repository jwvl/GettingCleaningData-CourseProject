## Script for Course Project of Getting and Cleaning Data course
# Requires that the ZIP data for the assignment be unpacked in the working directory,
# such that the directory structure is
# UCI HAT Dataset/
#  |- test/
#   |- X_test.txt
#   |- Y_test.txt
#   |- subject_test.txt
#  |- train/
#   |- X_train.txt
#   |- Y_train.txt
#   |- subject_train.txt
#  |- activity_labels.txt
#  |- features.txt
#
#
library(reshape2)


# This function reads the train and test files from their respective directories
# and merges them to a single table
mergeTrainingAndTestingSets <- function() {
    
    # Read test data and merge with cbind
    xTest<- read.table("UCI HAR Dataset/test/X_test.txt")
    subjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")
    yTest <-read.table("UCI HAR Dataset/test/Y_test.txt")
    xTest<-cbind(xTest,subjectTest)
    xTest<-cbind(xTest,yTest)
    
    # Read train data and merge with cbind
    xTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
    subjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")
    yTrain <-read.table("UCI HAR Dataset/train/Y_train.txt")
    xTrain<-cbind(xTrain,subjectTrain)
    xTrain<-cbind(xTrain,yTrain)
    
    # Append the training and testing sets with rbind
    result = rbind(xTest,xTrain)
    
    # Rename last columns
    lastCol = ncol(result)
    colnames(result)[lastCol-1] <- "subject"
    colnames(result)[lastCol] <- "activityID"
    
    result
}

## Adds the meaningful labels (instead of IDs) for the activity column to
## the data frame.
addActivityLabels <- function(df) {
    # Add meaningful activity labels
    activityLabels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep=" ",header=FALSE)
    colnames(activityLabels) <- c("id","activity")
    df<- merge(df,activityLabels, by.x="activityID", by.y="id")
    
    df
}

## Extract the relevant columns from the data frame, and cleans up their names.
extractOnlyMeansAndSDs <- function(df) {
    # Load file with column measurement data
    featureLabels <- read.csv("UCI HAR Dataset/features.txt",sep=" ",header=FALSE)
    nFeatures <- nrow(featureLabels)
    colsToKeep <- c("subject","activity")
    for (i in 1:nFeatures) {
        colNameToReplace <- paste("V",i,sep="")
        currLabel <- featureLabels[i,2]
        if (grepl("mean()",currLabel,fixed=TRUE) | grepl("std()",currLabel,fixed=TRUE)) {
        
        # Remove brackets; replace hyphens with dots
        currLabel <- gsub("(","",currLabel,fixed=TRUE)
        currLabel <- gsub(")","",currLabel,fixed=TRUE)
        currLabel <- gsub("-",".",currLabel,fixed=TRUE)
        
        currLabel <- tolower(currLabel)
        
        # Replace column names in data frame, all in lower case
        names(df)[names(df)==colNameToReplace] <- currLabel
        colsToKeep <- append(colsToKeep, currLabel)
        }
    }
    result <- df[,colsToKeep]
    result
}

## Returns a summarized data sets with the means for each variable per activity
## per subject.
averageVariables <- function(df) {
    molten<-melt(df, c("subject","activity"))
    dcast(molten, subject+activity~variable,mean)
}


## Stepwise through the instructions:

## 1 Merge the training and the test sets to create one data set.
fullSet<- mergeTrainingAndTestingSets()

## 3 Use descriptive activity names to name the activities in the data set
## 4 Appropriately label the data set with descriptive activity names. 
fullSet<- addActivityLabels(fullSet)


## 2 Extract only the measurements on the mean and standard deviation for each measurement. 
subsetted<- extractOnlyMeansAndSDs(fullSet)

## 5 Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidySet <- averageVariables(subsetted)

## Write to tab-separated file
write.table(tidySet,"tidyData.txt", sep="\t")