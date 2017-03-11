# Getting and Cleaning Data: Week 4 Course Project

## Introduction
This work is to demonstrate ability to collect, work with, and clean a data set.  

The task is provided by Coursera to be completed as the Week 4 assignment for Coursera's "Getting and Cleaning Data" course.

The provided data represent data collected from the accelerometers from Samsung Galaxy S smartphones.  

The task is:

1. To merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data Source:
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Code
The run_analysis.R script works by first reading the test and train data into data frames using the ````getDataset()```` function.

The script expects the working directory to be set to the directory containing run_analysis.R.

The ````getDataset()```` function combines the X, Y, activity label and subject and returns a data frame
````R
# Accepts an argument of "test" or "train"
# Combines X data, Y data, feature names and subjects of the provided type
# Returns a data frame
getDataset <- function(type) {
  # Check that a valid 'type' has been provided
  if(!type %in% c("test", "train")) {
    stop("Invalid dataset type provided. Please use \"Test\" or \"Train\"")
  }
  
  # Read X data
  X <- read.table(file = paste0("UCI HAR Dataset/", type, "/X_", type, ".txt"), header = F)
  
  # Read features lookup and apply to colnames
  feature_names <- read.table(file = "UCI HAR Dataset/features.txt", sep = " ", header = F)
  colnames(X) <- feature_names$V2
  
  # Read activity data
  y <- read.table(file = paste0("UCI HAR Dataset/", type, "/y_", type, ".txt"), header = F)
  X$activity_label <- y$V1
  
  # Read Subject data
  subject <- read.table(file = paste0("UCI HAR Dataset/", type, "/subject_", type, ".txt"), header = F)
  X$subject <- subject$V1
  
  # Return data frame
  return(X)
}

# Create complete test dataset
testData <- getDataset("test")

# Create complete train dataset
trainData <- getDataset("train")
````

The test and train data are then appended using the ````rbind()```` function
````R
# Append the test and train data into a single dataset
combinedDataset <- rbind(testData, trainData)
````

The combined dataset is then subset to include only columns for the mean, standard deviation, activity label and subject.

This is done by providing a data frame and regex expression as arguments to the ````removeColumns()```` function
````R
# Accepts a data frame and regex expression
# Return a data frame containing only columns that match the regex expression
removeColumns <- function(df, regex) {
  return(df[, grep(regex, colnames(df))])
}
# Filter dataset to include only means, standard deviations, activity labels and subject labels
mergedDataset.filtered <- removeColumns(mergedDataset, "(mean|std|activity_label|subject)")
````

The descriptive activity labels are then merged with the filtered dataset by using the ````addLabels()```` function.

The add labels function accepts a data frame that contains a column named 'activity_label'. It reads the activity labels data from activity_labels.txt and then returns a merged data frame that includes the descriptive activity labels.
````R
# Accepts a data frame that contains a column named 'activity_label'
# Returns the data frame with descriptive activity labels in the column 'activity'
addLabels <- function(df) {
  # Check that df contains 'activity_label' column
  if(!"activity_label" %in% colnames(df)) {
    stop("Could not find column 'activity_label'")
  }
  # Read activity label data and merge with df
  labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_label", "activity" ))
  return(merge(df, labels))
}
````

Finally, the labelled data are then summarised using the ````dplyr```` package, specifically, the ````dplyr::group_by()```` and ````dplyr::summarise_all()```` functions.

The summary is then saved to ````tidy_summary.txt```` using the ````write.table()```` function
````R
# Create sumarised dataset
library(dplyr)
# Create sumarised dataset
summary <- mergedDataset.filtered %>%
  group_by(subject, activity, activity_label) %>%
  summarise_all(mean) %>%
  arrange(subject, activity_label)

write.table(x = summary, file = "tidy_summary.txt", row.names = F)
````
