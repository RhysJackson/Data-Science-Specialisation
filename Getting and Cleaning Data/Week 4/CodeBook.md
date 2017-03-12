##CodeBook
This exercise has been carried out as part of the Week 4 assignement for the Coursera "Getting and Cleaning Data" course.
This codebook describes the variables, the data, and transformations that were performed to clean up the data.

##Data
The provided data represent data collected from the accelerometers from Samsung Galaxy S smartphones.  

Data Source:
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Files
The data consist of a test set, a training set. Also included are activity labels and features that are applicable to both training and test sets.

* `activity_labels.txt` provides descriptive labels for each activity class in the training and test sets
* `features.txt` the feature names for both the training and the test sets
* `/train/X_train.txt` the training set
* `/train/y_train.txt` the activity labels for the training set
* `/train/subject_train.txt` the subject labels for the training set
* `/test/X_test.txt` the test set
* `/test/y_test.txt` the activity labels for the test set
* `/test/subject_test.txt` the subject labels for the test set

In addition, the provided files include useful descriptive information
* `features_info.txt` Descriptions of each feature and how they were calculated.
* `README.txt` Provides detailed descriptions of each of the files

For the purposes of this exercise, the files contained within the `/test/Inertial Signals/` and `/train/Intertial Signals/` folders were not used.

## Exercise Goals
1. To merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

## Transformation Steps
The following transformation steps were conducted to achieve the exercise goals. Detailed descriptions of the steps can be found in README.md
* Read the test set and training set into memory, combining the activity and subject labels for each
* Append the training set and test set into a single data frame
* Filter the combined data to include only the mean, standard deviation, subject and activity columns
* Read the `activity_labels.txt` file into memory and merge with the filtered dataset to add descriptive activity labels
* Summarise the cleaned data by subject and activity, finding the mean of all values
* Write summary data to file `tidy_summary.txt`
