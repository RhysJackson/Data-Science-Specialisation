library(dplyr)

### PREPARE FUNCTIONS ###

# Accepts a data frame and regex expression
# Return a data frame containing only columns that match the regex expression
removeColumns <- function(df, regex) {
  return(df[, grep(regex, colnames(df))])
}

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


### PROCESS DATA ###

# Create complete test dataset
testData <- getDataset("test")

# Create complete train dataset
trainData <- getDataset("train")

# Append the test and train data into a single dataset
combinedDataset <- rbind(testData, trainData)

# Filter dataset to include only means, standard deviations, activity labels and subject labels
mergedDataset.filtered <- removeColumns(mergedDataset, "(mean|std|activity_label|subject)")

# Merge descriptive activity labels
mergedDataset.filtered <- addLabels(mergedDataset.filtered)

# Create sumarised dataset
summary <- mergedDataset.filtered %>%
  group_by(subject, activity, activity_label) %>%
  summarise_all(mean) %>%
  arrange(subject, activity_label)

write.table(x = summary, file = "tidy_summary.txt", row.names = F)
